<script setup lang="ts">
const props = defineProps<{
  id: string;
}>();

const supabase = useSupabaseClient();
const toast = useToast();
const loading = useloadingstore();
const { t } = useI18n();

async function confirm() {
  if (props.id) {
    loading.trigger = true;
    const { error } = await supabase.from("blocks").insert({
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
  <AppBlock :confirm="confirm" />
</template>
