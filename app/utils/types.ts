import type { Database } from "../../database.types";

type profilerow = Database["public"]["Tables"]["profiles"]["Row"];
export type titlerow = Database["public"]["Tables"]["titles"]["Row"];
type postrow = Database["public"]["Tables"]["posts"]["Row"];
type postimagerow = Database["public"]["Tables"]["post_images"]["Row"];
type notificationrow = Database["public"]["Tables"]["notifications"]["Row"];

export interface typeprofile extends profilerow {
  subs?: typesubs[] | null;
  titles: titlerow[] | null | undefined;
}

export interface typepost extends typesubs {
  subs?: typesubs[] | null;
}

export interface typeimage extends postimagerow {}

export interface typesubs extends postrow {
  profiles: typeprofile | null;
  likes: { count: number | null }[];
  posts: { count: number | null }[];
  is_liked: { count: number | null }[];
  isnew?: boolean;
  post_images: postimagerow[];
}

export interface typenotification extends notificationrow {
  profiles: profilerow | null;
}
