<script setup lang="ts">
defineOptions({ inheritAttrs: false });

const props = defineProps<{
  title: titlerow;
}>();

const { t } = useI18n();

function show() {
  if (!props.title.expiration_at)
    return true;
  return new Date(props.title.expiration_at) >= new Date();
}

const color = computed(() => {
  switch (props.title.type) {
    case "admin":
      return "badge-error";
    default:
      return "badge-neutral";
  }
});

const text = computed(() => {
  switch (props.title.type) {
    case "admin":
      return t("Admin");
    default:
      return t("Unknown");
  }
});
</script>

<template>
  <div v-if="show()">
    <div v-bind="$attrs" class="badge badge-sm cursor-pointer" :class="color">
      {{ text }}
    </div>
  </div>
</template>
