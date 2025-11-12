<script setup lang="ts">
defineProps<{
  severity: string;
  notification: typenotification;
}>();
</script>

<template>
  <div class="avatar placeholder cursor-pointer select-none">
    <div
      v-if="severity === 'info'"
      class="avatar bg-info text-neutral-content ring-base-100 w-12 rounded-full ring"
    />
    <div
      v-else-if="severity === 'success'"
      class="avatar bg-success text-neutral-content ring-base-100 w-12 rounded-full ring"
    />
    <div
      v-else-if="severity === 'warning'"
      class="avatar bg-warning text-neutral-content ring-base-100 w-12 rounded-full ring"
    />
    <div
      v-else-if="severity === 'error'"
      class="avatar bg-error text-neutral-content ring-base-100 w-12 rounded-full ring"
    />
    <ProfileAvatar
      v-else
      :id="notification.profiles?.id"
      :url="notification.profiles?.avatar_url"
      :name="notification.profiles?.name"
    />
  </div>
</template>
