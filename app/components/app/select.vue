<script setup lang="ts">
interface Option {
  label: string;
  value: string | number;
}

const props = defineProps<{
  options: Option[];
  disabled?: boolean;
}>();

const model = defineModel<string | number | null>();

watch(
  () => props.options,
  (opts) => {
    if ((!model.value || model.value === null) && opts.length > 0) {
      model.value = opts[0].value;
    }
  },
  { immediate: true },
);
</script>

<template>
  <select
    v-model="model"
    class="select w-full rounded-xl"
    :disabled="disabled || !options.length"
  >
    <option v-for="opt in options" :key="opt.value" :value="opt.value">
      {{ opt.label }}
    </option>
  </select>
</template>
