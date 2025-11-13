<script setup lang="ts">
const plugins = usepluginstore();

async function confirm() {
  useRouter().push(`${plugins.clipboard.link}`);
  plugins.clipboard.ignore = plugins.clipboard.link;
}
</script>

<template>
  <AppDialog
    :bus="plugins.clipboard.bus"
    :confirm="confirm"
    :cancel="async () => { plugins.clipboard.ignore = plugins.clipboard.link }"
    :content="$t('A share link was detected in the clipboard. Do you want to open it?')"
  />
</template>
