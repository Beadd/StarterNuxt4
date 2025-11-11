<script setup lang="ts">
defineProps<{
  name?: string | null;
}>();
</script>

<template>
  <div
    v-if="name" class="
      cursor-pointer opacity-50
      hover:underline
    "
  >
    @{{ name }}
  </div>
</template>
