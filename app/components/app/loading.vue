<script setup lang="ts">
const loading = useloadingstore();
</script>

<template>
  <div
    v-show="loading.trigger"
    class="bg-base-100/50 fixed inset-0 z-51 flex items-center justify-center"
    @click.stop
    @touchmove.stop.prevent
    @wheel.prevent
  >
    <span class="loading loading-ring loading-xl" />
  </div>
</template>
