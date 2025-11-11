<script setup lang="ts">
const props = defineProps<{
  id: string;
}>();

const supabase = useSupabaseClient();
const toast = useToast();
const loading = useloadingstore();
const { t } = useI18n();

const content = ref("");

async function confirm() {
  if (props.id) {
    loading.trigger = true;
    const { error } = await supabase.from("posts").insert({
      content: content.value,
      is_report: true,
      target_id: props.id,
    });

    if (!error) {
      loading.trigger = false;
      showtoastsuccess(toast, t);
    } else {
      loading.trigger = false;
      showtoasterror(toast, t);
    }
  }
}
</script>

<template>
  <AppOptreport v-model="content" :confirm="confirm" />
</template>
