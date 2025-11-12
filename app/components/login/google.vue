<script setup lang="ts">
import { Browser } from "@capacitor/browser";
import { Capacitor } from "@capacitor/core";

const supabase = useSupabaseClient();
const toast = useToast();
const { t } = useI18n();
const auths = useauthstore();

const bus = ref(0);

const produrl = Capacitor.isNativePlatform()
  ? import.meta.env.VITE_AUTH_REDIRECT_URL_NATIVE
  : import.meta.env.VITE_AUTH_REDIRECT_URL_PROD;

const redirecturl = import.meta.dev
  ? import.meta.env.VITE_AUTH_REDIRECT_URL
  : produrl;

async function oauth() {
  if (!auths.agreed) {
    bus.value++;
    return;
  }

  try {
    const { data, error } = await supabase.auth.signInWithOAuth({
      provider: "google",
      options: {
        redirectTo: redirecturl,
        skipBrowserRedirect: true,
      },
    });

    if (error)
      throw error;
    if (data?.url) {
      await Browser.open({ url: data.url, windowName: "_self" });
    }
  } catch {
    showtoasterror(toast, t);
  }
}
</script>

<template>
  <button
    class="btn w-full border-[#e5e5e5] bg-white text-black"
    @click="oauth"
  >
    <i class="bx bxl-google" />
    {{ $t("Continue with Google") }}
  </button>
  <AppDialog
    :bus="bus"
    :confirm="
      async () => {
        auths.agreed = true;
        await oauth();
      }
    "
    :cancel="async () => {}"
    content=""
  >
    <LoginPolicy />
  </AppDialog>
</template>
