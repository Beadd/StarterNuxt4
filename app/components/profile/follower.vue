<script setup lang="ts">
defineProps<{
  number?: number;
}>();

const id = useRoute().params.id;
</script>

<template>
  <div
    class="
      group cursor-pointer
      hover:underline
    "
    @click="useRouter().push(`/id/${id}/follower`)"
  >
    <span class="font-bold">{{ number }}</span>
    <span
      class="
        ml-1 opacity-50
        group-hover:opacity-100
      "
    >{{
      $t("Follower")
    }}</span>
  </div>
</template>
