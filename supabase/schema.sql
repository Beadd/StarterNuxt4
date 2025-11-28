
\restrict C3LlSbirpSYSCH4YCV9nlaGiO0fWbQmyFeAckRIbGzOHjn1opi9y7y07FZ5g01b


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE OR REPLACE FUNCTION "public"."check_admin"() RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$BEGIN
  RETURN EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND is_admin = true
  );
END;$$;


ALTER FUNCTION "public"."check_admin"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_notification_for_follow"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
  receiver_id UUID;
  target_name TEXT;
BEGIN

  IF NEW.target_id IS NOT NULL THEN
    SELECT id INTO receiver_id FROM profiles WHERE id = NEW.target_id;
  END IF;

  IF NEW.user_id IS NOT NULL THEN
    SELECT name INTO target_name FROM profiles WHERE id = NEW.user_id;
  END IF;

  IF receiver_id IS NOT NULL AND receiver_id <> NEW.user_id THEN
    INSERT INTO notifications (
      title,
      link,
      receiver_id,
      sender_id,
      type
    ) VALUES (
      target_name,
      '/id/' || NEW.user_id,
      receiver_id,
      NEW.user_id,
      'follow'
    );
  END IF;

  RETURN NEW;
END;$$;


ALTER FUNCTION "public"."create_notification_for_follow"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_notification_for_like"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
  receiver_id UUID;
  content_title TEXT;
  notification_link TEXT;
BEGIN

  IF NEW.post_id IS NOT NULL THEN
    SELECT user_id INTO receiver_id FROM posts WHERE id = NEW.post_id;
    SELECT LEFT(content, 20) INTO content_title FROM posts WHERE id = NEW.post_id;
    notification_link := '/posts/' || NEW.post_id;
  END IF;
  
  IF receiver_id IS NOT NULL AND receiver_id <> auth.uid() THEN
    INSERT INTO notifications (
      title,
      link,
      receiver_id,
      sender_id,
      type
    ) VALUES (
      COALESCE(content_title, ''),
      notification_link,
      receiver_id,
      auth.uid(),
      'like'
    );
  END IF;
  
  RETURN NEW;
END;$$;


ALTER FUNCTION "public"."create_notification_for_like"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_notification_for_new"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
  insert into public.notifications(receiver_id, sender_id, type, link)
  values(new.id, new.id, 'welcome', '/id/' || new.id);
  return new;
END;$$;


ALTER FUNCTION "public"."create_notification_for_new"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_notification_for_post"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
  receiver_id UUID;
  notification_link TEXT;
  notification_type TEXT;
BEGIN
  IF NEW.is_report = true THEN
    RETURN NEW;
  END IF;

  IF NEW.post_id IS NOT NULL THEN
    SELECT user_id INTO receiver_id FROM posts WHERE id = NEW.post_id;
    notification_link := '/posts/' || NEW.post_id;
    notification_type := 'post';
  END IF;
    
  IF receiver_id IS NOT NULL AND receiver_id <> NEW.user_id THEN
    INSERT INTO notifications (
      title,
      link,
      receiver_id,
      sender_id,
      type
    ) VALUES (
      LEFT(NEW.content, 20),
      notification_link,
      receiver_id,
      NEW.user_id,
      notification_type
    );
  END IF;
  
  RETURN NEW;
END;$$;


ALTER FUNCTION "public"."create_notification_for_post"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_profile_for_new"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
insert into public.profiles(id,name,avatar_url, online_duration)
values(
  new.id,
  COALESCE(new.raw_user_meta_data->>'full_name', null), 
  md5(lower(trim(new.email))),
  0
);
return new;
END;$$;


ALTER FUNCTION "public"."create_profile_for_new"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_friends"("user_id" "uuid", "last_created_at" timestamp without time zone) RETURNS json
    LANGUAGE "plpgsql"
    AS $_$DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
      'id', sub.target_id,
      'created_at', sub.created_at
    ))
  INTO result
  FROM (
    SELECT 
      f1.target_id,
      f1.created_at 
    FROM follows f1
    WHERE f1.user_id = $1
    AND EXISTS (
      SELECT 1
      FROM follows f2
      WHERE f2.user_id = f1.target_id
      AND f2.target_id = $1
    )
    AND f1.created_at < $2
    ORDER BY f1.created_at DESC
    LIMIT 10
  ) AS sub;

  RETURN result;
END;$_$;


ALTER FUNCTION "public"."get_friends"("user_id" "uuid", "last_created_at" timestamp without time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_friends_number"("user_id" "uuid") RETURNS integer
    LANGUAGE "plpgsql"
    AS $_$DECLARE
    mutual_count bigint;
BEGIN
    SELECT COUNT(*) INTO mutual_count
    FROM follows f1
    WHERE f1.user_id = $1
    AND EXISTS (
        SELECT 1
        FROM follows f2
        WHERE f2.user_id = f1.target_id
        AND f2.target_id = $1
    );
    RETURN mutual_count;
END;$_$;


ALTER FUNCTION "public"."get_friends_number"("user_id" "uuid") OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."blocks" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "target_id" "uuid"
);


ALTER TABLE "public"."blocks" OWNER TO "postgres";


ALTER TABLE "public"."blocks" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."blocks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."follows" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "target_id" "uuid"
);


ALTER TABLE "public"."follows" OWNER TO "postgres";


ALTER TABLE "public"."follows" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."follows_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."likes" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "post_id" "uuid"
);


ALTER TABLE "public"."likes" OWNER TO "postgres";


ALTER TABLE "public"."likes" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."likes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."notifications" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deleted_at" timestamp with time zone,
    "receiver_id" "uuid",
    "sender_id" "uuid",
    "content" character varying,
    "type" character varying,
    "link" character varying,
    "is_read" boolean
);


ALTER TABLE "public"."notifications" OWNER TO "postgres";


ALTER TABLE "public"."notifications" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."notifications_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."post_images" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "post_id" "uuid",
    "link" character varying,
    "width" integer,
    "height" integer
);


ALTER TABLE "public"."post_images" OWNER TO "postgres";


ALTER TABLE "public"."post_images" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."post_images_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."posts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deleted_at" timestamp with time zone,
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "content" character varying,
    "post_id" "uuid",
    "is_report" boolean,
    "target_id" "uuid",
    "banned_at" timestamp with time zone
);


ALTER TABLE "public"."posts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deleted_at" timestamp with time zone,
    "uid" bigint NOT NULL,
    "name" character varying,
    "username" character varying,
    "avatar_url" character varying,
    "is_vip" boolean,
    "is_admin" boolean,
    "banned_at" timestamp with time zone,
    "online_duration" bigint
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


ALTER TABLE "public"."profiles" ALTER COLUMN "uid" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."profiles_uid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."titles" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "deleted_at" timestamp with time zone,
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "type" character varying,
    "expiration_at" timestamp with time zone
);


ALTER TABLE "public"."titles" OWNER TO "postgres";


ALTER TABLE "public"."titles" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."titles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE ONLY "public"."blocks"
    ADD CONSTRAINT "blocks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."follows"
    ADD CONSTRAINT "follows_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."likes"
    ADD CONSTRAINT "likes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."post_images"
    ADD CONSTRAINT "post_images_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."posts"
    ADD CONSTRAINT "posts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_uid_key" UNIQUE ("uid");



ALTER TABLE ONLY "public"."titles"
    ADD CONSTRAINT "titles_pkey" PRIMARY KEY ("id");



CREATE OR REPLACE TRIGGER "create_notification_for_follow" BEFORE INSERT ON "public"."follows" FOR EACH ROW EXECUTE FUNCTION "public"."create_notification_for_follow"();



CREATE OR REPLACE TRIGGER "create_notification_for_like" BEFORE INSERT ON "public"."likes" FOR EACH ROW EXECUTE FUNCTION "public"."create_notification_for_like"();



CREATE OR REPLACE TRIGGER "create_notification_for_post" BEFORE INSERT ON "public"."posts" FOR EACH ROW EXECUTE FUNCTION "public"."create_notification_for_post"();



ALTER TABLE ONLY "public"."follows"
    ADD CONSTRAINT "follows_target_id_fkey" FOREIGN KEY ("target_id") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."follows"
    ADD CONSTRAINT "follows_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."likes"
    ADD CONSTRAINT "likes_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id");



ALTER TABLE ONLY "public"."likes"
    ADD CONSTRAINT "likes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."notifications"
    ADD CONSTRAINT "notifications_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."post_images"
    ADD CONSTRAINT "post_images_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id");



ALTER TABLE ONLY "public"."posts"
    ADD CONSTRAINT "posts_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."posts"("id");



ALTER TABLE ONLY "public"."posts"
    ADD CONSTRAINT "posts_target_id_fkey" FOREIGN KEY ("target_id") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."posts"
    ADD CONSTRAINT "posts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id");



ALTER TABLE ONLY "public"."titles"
    ADD CONSTRAINT "titles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id");



ALTER TABLE "public"."blocks" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."follows" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."likes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."notifications" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."post_images" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."posts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."titles" ENABLE ROW LEVEL SECURITY;


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."check_admin"() TO "anon";
GRANT ALL ON FUNCTION "public"."check_admin"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."check_admin"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_notification_for_follow"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_notification_for_follow"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_notification_for_follow"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_notification_for_like"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_notification_for_like"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_notification_for_like"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_notification_for_new"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_notification_for_new"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_notification_for_new"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_notification_for_post"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_notification_for_post"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_notification_for_post"() TO "service_role";



GRANT ALL ON FUNCTION "public"."create_profile_for_new"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_profile_for_new"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_profile_for_new"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_friends"("user_id" "uuid", "last_created_at" timestamp without time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."get_friends"("user_id" "uuid", "last_created_at" timestamp without time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_friends"("user_id" "uuid", "last_created_at" timestamp without time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_friends_number"("user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."get_friends_number"("user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_friends_number"("user_id" "uuid") TO "service_role";



GRANT ALL ON TABLE "public"."blocks" TO "anon";
GRANT ALL ON TABLE "public"."blocks" TO "authenticated";
GRANT ALL ON TABLE "public"."blocks" TO "service_role";



GRANT ALL ON SEQUENCE "public"."blocks_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."blocks_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."blocks_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."follows" TO "anon";
GRANT ALL ON TABLE "public"."follows" TO "authenticated";
GRANT ALL ON TABLE "public"."follows" TO "service_role";



GRANT ALL ON SEQUENCE "public"."follows_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."follows_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."follows_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."likes" TO "anon";
GRANT ALL ON TABLE "public"."likes" TO "authenticated";
GRANT ALL ON TABLE "public"."likes" TO "service_role";



GRANT ALL ON SEQUENCE "public"."likes_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."likes_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."likes_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."notifications" TO "anon";
GRANT ALL ON TABLE "public"."notifications" TO "authenticated";
GRANT ALL ON TABLE "public"."notifications" TO "service_role";



GRANT ALL ON SEQUENCE "public"."notifications_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."notifications_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."notifications_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."post_images" TO "anon";
GRANT ALL ON TABLE "public"."post_images" TO "authenticated";
GRANT ALL ON TABLE "public"."post_images" TO "service_role";



GRANT ALL ON SEQUENCE "public"."post_images_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."post_images_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."post_images_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."posts" TO "anon";
GRANT ALL ON TABLE "public"."posts" TO "authenticated";
GRANT ALL ON TABLE "public"."posts" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON SEQUENCE "public"."profiles_uid_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."profiles_uid_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."profiles_uid_seq" TO "service_role";



GRANT ALL ON TABLE "public"."titles" TO "anon";
GRANT ALL ON TABLE "public"."titles" TO "authenticated";
GRANT ALL ON TABLE "public"."titles" TO "service_role";



GRANT ALL ON SEQUENCE "public"."titles_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."titles_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."titles_id_seq" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";






\unrestrict C3LlSbirpSYSCH4YCV9nlaGiO0fWbQmyFeAckRIbGzOHjn1opi9y7y07FZ5g01b

RESET ALL;
