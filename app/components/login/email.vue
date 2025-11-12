<script setup lang="ts">
const auths = useauthstore();
const supabase = useSupabaseClient();
const toast = useToast();
const { t } = useI18n();

const email = ref("");
const bus = ref(0);
const el = ref<{ toggle: () => Promise<void> } | null>(null);

async function click() {
  if (auths.agreed) {
    await send();
  } else {
    bus.value++;
  }
}

async function send() {
  const now = Date.now();
  if (auths.lastemail === email.value && now - auths.lasttime < 180000) {
    useRouter().push(`/auth/confirm?email=${encodeURIComponent(email.value)}`);
    return;
  }

  auths.lastemail = email.value;
  auths.lasttime = now;

  const { error } = await supabase.auth.signInWithOtp({
    email: email.value,
    options: {
      shouldCreateUser: true,
    },
  });

  if (!error) {
    auths.begin();

    showtoastsuccess(toast, t);

    useRouter().push(`/auth/confirm?email=${encodeURIComponent(email.value)}`);
  } else {
    showtoasterror(toast, t);
  }
}
</script>

<template>
  <AppInput>
    <i class="bx bxs-envelope" />
    <input
      v-model="email"
      type="email"
      class="grow"
      :placeholder="$t('Email')"
      autocomplete="email"
    >
  </AppInput>
  <AppBtn ref="el" class="w-full" :load="click">
    <i class="bx bxs-envelope" />
    {{ $t("Continue with Email") }}
  </AppBtn>
  <AppDialog
    :bus="bus"
    :confirm="
      async () => {
        auths.agreed = true;
        el?.toggle();
      }
    "
    :cancel="async () => {}"
    content=""
  >
    <LoginPolicy />
  </AppDialog>
</template>
