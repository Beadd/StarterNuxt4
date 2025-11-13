<script setup lang="ts">
function download() {
  const link = document.createElement("a");
  link.href = "/example.apk";
  link.download = "example.apk";
  link.click();
}
</script>

<template>
  <AppFrame>
    <AppBar :title="$t('Get the mobile app')" />
    <AppOpt @click="download">
      {{ $t("Download the APK file") }}
    </AppOpt>
  </AppFrame>
</template>
