<script setup lang="ts">
const supabase = useSupabaseClient();
const user = useSupabaseUser();

const profiles = useprofilestore();
const last = ref<string | null>(null);
const more = ref(true);

profiles.report = [];

async function load() {
  const last_created_at = last.value
    ? last.value || new Date().toISOString()
    : new Date().toISOString();

  const { data } = await supabase
    .from("profiles")
    .select(
      `
      *,
      titles(*),
      subs:posts!posts_target_id_fkey(
        *, 
        profiles!posts_user_id_fkey(*,titles(*)),
        likes(count),
        posts(count),
        is_liked:likes(count),
        post_images(*)
      )
    `,
    )
    .is("deleted_at", null)
    .is("banned_at", null)
    .not("subs", "is", null)
    .is("subs.deleted_at", null)
    .is("subs.is_report", true)
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
  profiles.report.push(...data);
}
</script>

<template>
  <Navbar>
    <AppFrame>
      <AppBar :title="$t('User reports')" />
      <ProfileUser
        v-for="profile in profiles.report"
        :key="profile.id"
        :profile="profile"
      />
      <AppLoadder :load="load" :more="more" />
    </AppFrame>
  </Navbar>
</template>
