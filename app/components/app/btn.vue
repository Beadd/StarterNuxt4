<script setup lang="ts">
defineProps<{
  load: () => Promise<void>;
}>();

const bus = ref(0);

defineExpose({
  toggle: async () => {
    bus.value++;
  },
});
</script>

<template>
  <button class="btn" @click="bus++">
    <AppLoad :bus="bus" :load="load" :more="false">
      <slot />
    </AppLoad>
  </button>
</template>
