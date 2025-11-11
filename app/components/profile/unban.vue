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
      .update({ banned_at: null })
      .match({ id: props.id });

    if (!error) {
      profiles.unban(props.id);

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
  <div class="btn" @click="bus++">
    {{ $t("Unban user") }}
  </div>
  <AppDialog
    :bus="bus"
    :confirm="confirm"
    :cancel="async () => {}"
    :content="$t('Confirm unban')"
  />
</template>
