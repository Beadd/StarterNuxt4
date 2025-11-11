<script setup lang="ts">
const props = defineProps<{
  id: string;
}>();

const user = useSupabaseUser();
const supabase = useSupabaseClient();
const posts = usepoststore();

const more = ref(true);
const last = ref<string | null>(null);

posts.profile = [];

async function load() {
  let query = supabase
    .from("posts")
    .select(
      `
      *, 
      profiles!posts_user_id_fkey(*,titles(*)),
      likes(count),
      posts(count),
      is_liked:likes(count),
      post_images(*),
      subs:posts(
        *, 
        profiles!posts_user_id_fkey(*,titles(*)),
        likes(count),
        posts(count),
        is_liked:likes(count),
        post_images(*)
      )
      `,
    )
    .eq("user_id", props.id)
    .is("post_id", null)
    .is("deleted_at", null)
    .is("is_report", null)
    .eq("is_liked.user_id", user.value?.id || defaultuuid)
    .is("subs.deleted_at", null)
    .is("subs.banned_at", null)
    .is("subs.is_report", null)
    .eq("subs.is_liked.user_id", user.value?.id || defaultuuid)
    .order("created_at", { ascending: false })
    .limit(10)
    .limit(2, { foreignTable: "subs" })
    .order("created_at", { ascending: false, referencedTable: "subs" });

  if (props.id !== user.value?.id) {
    query = query.is("banned_at", null);
  }

  if (last.value) {
    query = query.lt("created_at", last.value);
  }

  const { data } = await query;

  if (!data) {
    more.value = false;
    return;
  }

  if (data.length < 10)
    more.value = false;

  last.value = data[data.length - 1]?.created_at || null;

  posts.profile.push(...data);
}
</script>

<template>
  <Post v-for="post in posts.profile" :key="post.id" :post="post" />
  <AppLoadder :load="load" :more="more" />
</template>
