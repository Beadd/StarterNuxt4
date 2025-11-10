<script setup lang="ts">
defineProps<{
  count?: number;
}>();

const button = ref(null);
const hovered = useElementHover(button);

const icon = computed(() => [hovered.value ? "bg-info/30" : "opacity-70"]);
</script>

<template>
  <button
    ref="button"
    class="
      hover:text-info
      flex cursor-pointer items-center justify-center
    "
  >
    <i
      class="
        bx bx-comment rounded-full p-3 transition-all duration-200 ease-linear
      "
      :class="icon"
    />
    <span class="text-sm opacity-70">{{ count || 0 }}</span>
  </button>
</template>
