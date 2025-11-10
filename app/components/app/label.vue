<script setup lang="ts">
defineProps<{
  click?: () => Promise<void>;
}>();

const toggle = defineModel();
</script>

<template>
  <label class="label w-full cursor-pointer justify-between">
    <span :class="{ 'text-primary': toggle }" class="label-text text-base">
      <slot />
    </span>
    <input v-model="toggle" type="checkbox" class="toggle" @click="click">
  </label>
</template>
