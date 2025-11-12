<script setup lang="ts">
import { Capacitor } from "@capacitor/core";
</script>

<template>
  <button
    v-if="!Capacitor.isNativePlatform()"
    class="btn w-full bg-[#211c18] text-white"
    @click="useRouter().push('app')"
  >
    <i class="bx bx-cloud-download" />
    {{ $t("Get the mobile app") }}
  </button>
</template>
