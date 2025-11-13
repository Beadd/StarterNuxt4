<script setup lang="ts">
import { Browser } from "@capacitor/browser";

const domain: string = import.meta.env.VITE_DOMAIN;

async function privacy() {
  await Browser.open({ url: `${domain}privacy.html` });
}

async function terms() {
  await Browser.open({ url: `${domain}terms.html` });
}
</script>

<template>
  <Navbar>
    <AppFrame>
      <AppBar :title="$t('Setting')" />
      <SettingLanguage />
      <AppOpt @click="terms">
        {{ $t("Terms of Service") }}
      </AppOpt>
      <AppOpt @click="privacy">
        {{ $t("Privacy Policy") }}
      </AppOpt>
    </AppFrame>
  </Navbar>
</template>
