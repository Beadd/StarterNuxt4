<script setup lang="ts">
defineProps<{
  error?: boolean;
}>();
</script>

<template>
  <label class="input w-full rounded-lg" :class="{ 'input-error': error }">
    <slot />
  </label>
</template>
