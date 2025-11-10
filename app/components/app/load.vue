<script setup lang="ts">
const props = defineProps<{
  load: () => Promise<void>;
  over?: () => Promise<void>;
  bus: number;
  more: boolean;
}>();

const pending = ref(false);

watch(
  () => props.bus,
  async () => {
    if (!pending.value) {
      pending.value = true;
      try {
        await props.load();
        if (props.over) {
          await props.over();
        }
      } finally {
        pending.value = false;
      }
    }
  },
);
</script>

<template>
  <span v-if="pending" :class="$attrs.class" class="loading loading-spinner" />
  <span v-else-if="more" class="loading loading-spinner" />
  <slot v-else />
</template>
