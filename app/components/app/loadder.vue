<script setup lang="ts">
defineProps<{
  load: () => Promise<void>;
  more: boolean;
}>();

const bus = ref(0);
const target = ref<HTMLElement | null>(null);
const visible = useElementVisibility(target);

watch(visible, () => {
  if (visible.value) {
    bus.value++;
  }
});

async function over() {
  setTimeout(() => {
    if (visible.value)
      bus.value++;
  }, 1000);
}
</script>

<template>
  <div ref="target" class="mb-32 flex h-16 w-full items-end justify-center">
    <div class="block">
      <AppLoad v-if="more" :load="load" :over="over" :bus="bus" :more="more" />
      <span v-else>{{ $t("No more") }}</span>
    </div>
  </div>
</template>
