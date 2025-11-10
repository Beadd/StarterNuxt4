<script setup lang="ts">
defineProps<{
  name?: string | null;
}>();
</script>

<template>
  <span v-if="name">
    {{ name }}
  </span>
  <span v-else>
    {{ $t("This content has been deleted or banned") }}
  </span>
</template>
