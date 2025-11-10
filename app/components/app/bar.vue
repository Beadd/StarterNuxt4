<script setup lang="ts">
defineProps<{
  title?: string | null;
  show?: boolean;
}>();

const profiles = useprofilestore();
</script>

<template>
  <div class="sticky top-0 z-21 w-full backdrop-blur-xl">
    <div class="h-st w-full" />
    <div class="border-neutral flex h-16 w-full border-b">
      <div class="flex h-full w-full items-center justify-between gap-4 px-4">
        <div class="flex items-center gap-2">
          <AppMenu v-if="show" class="p-0!" @click="useRouter().push('/mine')">
            <ProfileAvatar
              :id="profiles.item?.id || ''"
              class="m-3 max-w-9"
              :name="profiles.item?.name"
              :url="profiles.item?.avatar_url"
              :prevent="true"
            />
          </AppMenu>
          <AppMenu v-else @click="useRouter().back()">
            <i class="bx bx-chevron-left-circle text-primary text-3xl" />
          </AppMenu>
          <ProfileName
            class="
              text-2xl
              hover:no-underline!
            " :name="title"
          />
        </div>
        <slot />
      </div>
    </div>
    <slot name="sticky" />
  </div>
</template>
