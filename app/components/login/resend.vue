<script setup lang="ts">
const supabase = useSupabaseClient();
const route = useRoute();
const auths = useauthstore();
const toast = useToast();
const { t } = useI18n();

const email = route.query.email as string;
const bus = ref(0);

auths.resume();

async function resend() {
  const { error } = await supabase.auth.signInWithOtp({
    email,
    options: {
      shouldCreateUser: true,
    },
  });

  if (!error) {
    auths.begin();
    auths.lasttime = Date.now();

    showtoastsuccess(toast, t);
  } else {
    showtoasterror(toast, t);
  }
}
</script>

<template>
  <div v-if="auths.counter > 0">
    {{ $t("Please wait") }}
    <span class="countdown ml-1">
      <span :style="`--value: ${auths.counter}`" />...
    </span>
  </div>
  <div v-else class="text-secondary underline" @click="bus++">
    {{ $t("Don't get the code?") }}
  </div>
  <AppDialog
    :confirm="resend"
    :bus="bus"
    :content="$t('Confirm resending verification code')"
    :cancel="async () => {}"
  />
</template>
