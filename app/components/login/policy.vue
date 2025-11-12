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
  <span>
    {{ $t("I have read and agree to the") }}
    <a class="link link-primary" @click="terms">
      {{ $t("Terms of Service") }}
    </a>
    {{ $t("and") }}
    <a class="link link-primary" @click="privacy">
      {{ $t("Privacy Policy") }}
    </a>
  </span>
</template>
