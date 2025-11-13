<script setup lang="ts">
import { displayName } from "../package.json";

useHead({
  title: displayName,
  htmlAttrs: {
    class: "select-none",
  },
  meta: [
    {
      name: "viewport",
      content: "width=device-width, initial-scale=1, maximum-scale=1",
    },
  ],
});
</script>

<template>
  <NuxtLoadingIndicator color="#1d9bf0" :throttle="0" class="top-st!" />
  <NuxtLayout>
    <NuxtPage />
    <PluginClipboard />
  </NuxtLayout>
  <AppLoading />
  <AppToast />
</template>
