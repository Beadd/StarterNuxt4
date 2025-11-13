<script setup lang="ts">
const supabase = useSupabaseClient();
const user = useSupabaseUser();

const posts = usepoststore();
const last = ref<string | null>(null);
const more = ref(true);

posts.report = [];

async function load() {
  const last_created_at = last.value
    ? last.value || new Date().toISOString()
    : new Date().toISOString();

  const { data } = await supabase
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
    .not("book_id", "is", null)
    .is("point_id", null)
    .is("note_point_id", null)
    .is("deleted_at", null)
    .is("banned_at", null)
    .eq("is_report", true)
    .eq("is_liked.user_id", user.value?.id || defaultuuid)
    .eq("subs.is_liked.user_id", user.value?.id || defaultuuid)
    .order("created_at", { ascending: false })
    .lt("created_at", last_created_at)
    .limit(10)
    .limit(2, { foreignTable: "subs" })
    .order("created_at", { ascending: false, referencedTable: "subs" });

  if (!data) {
    more.value = false;
    return;
  }

  if (data.length < 10)
    more.value = false;
  last.value = data[data.length - 1]?.created_at || null;
  posts.report.push(...data);
}
</script>

<template>
  <Navbar>
    <AppFrame>
      <AppBar :title="$t('Post reports')" />
      <Post v-for="post in posts.report" :key="post.id" :post="post" />
      <AppLoadder :load="load" :more="more" />
    </AppFrame>
  </Navbar>
</template>
