<script setup lang="ts">
defineProps<{
  name?: number;
}>();
</script>

<template>
  <div
    class="
      cursor-pointer opacity-50
      hover:underline
    "
  >
    @{{ name }}
  </div>
</template>
