<script setup lang="ts">
defineProps<{
  confirm: () => Promise<void>;
}>();
const content = defineModel<string>();

const bus = ref(0);
const user = useSupabaseUser();
</script>

<template>
  <AppOpt @click="bus++">
    <div class="flex items-center gap-2">
      <i class="bx bxs-flag-checkered" />
      {{ $t("Report") }}
    </div>
  </AppOpt>
  <AppDialog
    :bus="bus"
    :confirm="confirm"
    :cancel="async () => {}"
    :content="$t('Confirm report')"
  >
    <AppTextarea
      v-model="content"
      :placeholder="
        user ? $t('Please enter the report content') : $t('Please log in first')
      "
      auto-resize
      rows="3"
      :disabled="!user"
    />
  </AppDialog>
</template>
