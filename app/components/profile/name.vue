<script setup lang="ts">
const props = defineProps<{
  name?: string | null;
  id?: string;
}>();

const url = computed(() => (props.id ? `/id/${props.id}` : undefined));
</script>

<template>
  <app-a
    class="
      cursor-pointer font-bold
      hover:underline
    "
    :url="url"
    @click.stop
  >
    <span v-if="name">{{ name }}</span>
    <span v-else>{{ $t("Email user") }}</span>
  </app-a>
</template>
