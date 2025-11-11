<script setup lang="ts">
defineProps<{
  profile: typeprofile;
  timercount?: number;
}>();

const profiles = useprofilestore();
</script>

<template>
  <div class="flex items-center gap-4 p-4">
    <ProfileAvatar
      :id="profile.id || ''"
      :name="profile.name"
      :url="profile.avatar_url"
    />
    <div class="flex flex-1 flex-col">
      <div class="flex flex-wrap items-baseline gap-1">
        <ProfileName :id="profile.id || ''" :name="profile.name" />
        <ProfileTitle
          v-for="(title, index) in profile.titles"
          :key="index"
          :title="title"
        />
      </div>
      <div class="flex gap-1">
        <ProfileUid v-if="profile.uid" :name="profile.uid" />
        <ProfileUsername :name="profile.username || ''" />
      </div>
    </div>
    <div class="flex items-center">
      <slot />
    </div>
  </div>
  <div v-if="profiles.item?.is_admin" class="flex flex-wrap gap-4 p-4">
    <ProfileBan v-if="!profile.banned_at" :id="profile.id" />
    <ProfileUnban v-else :id="profile.id" />
  </div>
</template>
