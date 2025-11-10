<script setup lang="ts">
defineProps<{
  confirm: () => Promise<void>;
}>();

const bus = ref(0);
</script>

<template>
  <AppOpt @click="bus++">
    <div class="text-error flex items-center gap-2">
      <i class="bx bx-trash" />
      {{ $t("Delete") }}
    </div>
  </AppOpt>
  <AppDialog
    :bus="bus"
    :confirm="confirm"
    :cancel="async () => {}"
    :content="$t('Confirm deletion')"
  />
</template>
