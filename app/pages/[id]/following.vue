<script setup lang="ts">
const user = useSupabaseUser();
const supabase = useSupabaseClient();

const id = useRoute().params.id as string;
const last = ref<string | null>(null);
const more = ref(true);
const profiles = ref<
  ((typeprofile | null | undefined) & { isfollow: boolean })[]
    >([]);

async function load() {
  let query = supabase
    .from("follows")
    .select(
      `
      *,
      profiles!follows_target_id_fkey(
        *,
        titles(*),
        follows!follows_target_id_fkey(count)
      )
    `,
    )
    .eq("user_id", id)
    .filter("profiles.follows.user_id", "eq", user.value?.id || defaultuuid)
    .order("created_at", { ascending: false })
    .limit(10);

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

  const newusers = data
    .filter(item => item.profiles)
    .map(item => ({
      ...item.profiles!,
      isfollow: (item.profiles!.follows?.[0]?.count || 0) > 0,
    }));

  profiles.value.push(...newusers);
}
</script>

<template>
  <Navbar>
    <AppFrame>
      <AppBar :title="$t('Following')" />
      <ProfileUser
        v-for="profile in profiles"
        :key="profile.id"
        :profile="profile"
        :isfollow="true"
      >
        <ProfileFollow
          :userid="profile?.id || ''"
          :isfollow="profile?.isfollow"
        />
      </ProfileUser>
      <AppLoadder :load="load" :more="more" />
    </AppFrame>
  </Navbar>
</template>
