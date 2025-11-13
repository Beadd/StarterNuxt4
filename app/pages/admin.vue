<script setup lang="ts">
const supabase = useSupabaseClient();

const [usercount, postcount] = await Promise.all([
  supabase.from("profiles").select("id", { count: "exact", head: true }),
  supabase.from("posts").select("id", { count: "exact", head: true }),
]);
</script>

<template>
  <Navbar>
    <AppFrame>
      <AppBar :title="$t('Admin Interface')" />
      <div class="flex w-full items-center justify-evenly">
        <AppStat :title="$t('Total users')" :count="usercount.count || 0" />
        <AppStat :title="$t('Total posts')" :count="postcount.count || 0" />
      </div>
      <div class="flex flex-col gap-4 p-4">
        <span>{{ $t('User list') }}</span>
      </div>
      <AdminUsers />
    </AppFrame>
  </Navbar>
</template>
