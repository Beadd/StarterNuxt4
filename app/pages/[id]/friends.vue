<script setup lang="ts">
const user = useSupabaseUser();
const supabase = useSupabaseClient();

const id = useRoute().params.id as string;
const last = ref<string | null>(null);
const more = ref(true);
const profiles = ref<(typeprofile & { isfollow: boolean })[]>([]);

async function load() {
  const last_created_at = last.value
    ? last.value || new Date().toISOString()
    : new Date().toISOString();

  const { data } = await supabase.rpc("get_friends", {
    last_created_at,
    user_id: id,
  });

  // @ts-expect-error for supabase rpc
  const friends: { id: string; created_at: string }[] = data;

  if (!friends) {
    more.value = false;
    return;
  }

  if (friends.length < 10)
    more.value = false;
  last.value = friends[friends.length - 1]?.created_at || null;

  const { data: users } = await supabase
    .from("profiles")
    .select(
      `
        *,
        titles(*),
        follows!follows_target_id_fkey(count)
      `,
    )
    .in(
      "id",
      friends.map(friend => friend.id),
    )
    .eq("follows.user_id", user.value?.id || defaultuuid);

  if (!users) {
    more.value = false;
    return;
  }

  const newusers = users.map(item => ({
    ...item,
    isfollow: (item.follows[0]?.count || 0) > 0,
  }));

  profiles.value.push(...newusers);
}
</script>

<template>
  <Navbar>
    <AppFrame>
      <AppBar :title="$t('Friends')" />
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
