<script setup lang="ts">
defineProps<{
  path: string;
  name: string;
  warning?: boolean;
}>();

const router = useRouter();
</script>

<template>
  <div
    class="
      flex h-12 w-full cursor-pointer items-center justify-center
      overflow-hidden rounded-xl border-2 text-center
    "
    :class="
      warning
        ? 'bg-warning/50 border-warning text-warning'
        : 'bg-secondary/30 border-secondary text-secondary'
    "
    @click="router.push(path)"
  >
    <div class="flex items-center justify-center gap-2">
      <i class="bx bx-plus" />
      {{ name }}
    </div>
  </div>
</template>
