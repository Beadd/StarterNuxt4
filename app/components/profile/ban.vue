<script setup lang="ts">
const props = defineProps<{
  id: string;
}>();

const supabase = useSupabaseClient();
const toast = useToast();
const loading = useloadingstore();
const { t } = useI18n();
const profiles = useprofilestore();

const bus = ref(0);

async function confirm() {
  if (props.id) {
    loading.trigger = true;
    const { error } = await supabase
      .from("profiles")
      .update({ banned_at: new Date().toISOString() })
      .match({ id: props.id });

    if (!error) {
      profiles.ban(props.id);

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
  <div class="btn btn-warning" @click="bus++">
    {{ $t("Ban user") }}
  </div>
  <AppDialog
    :bus="bus"
    :confirm="confirm"
    :cancel="async () => {}"
    :content="$t('Confirm ban')"
  />
</template>
