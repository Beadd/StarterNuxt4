<script setup lang="ts">
const user = useSupabaseUser();
</script>

<template>
  <Navbar :dock="true">
    <AppFrame>
      <AppBar :title="$t('Mine')" :show="true" />
      <AppOpt @click="useRouter().push(`/id/${user?.id}`)">
        <div class="flex items-center gap-2">
          <i class="bx bx-user-circle" />
          {{ $t("Profile") }}
        </div>
      </AppOpt>
      <AppOpt @click="useRouter().push('/setting')">
        <div class="flex items-center gap-2">
          <i class="bx bx-cog" />
          {{ $t("Setting") }}
        </div>
      </AppOpt>
      <MineSignout />
      <MineAdmin />
      <MineApp />
    </AppFrame>
  </Navbar>
</template>
