<script setup>
import { displayName, version } from "../package.json";

const auths = useauthstore();
</script>

<template>
  <div class="flex h-dvh flex-col items-center justify-between p-4">
    <div
      class="flex w-full max-w-72 grow flex-col items-center justify-center gap-4"
    >
      <div class="flex flex-col items-center">
        {{ $t("Welcome back") }}
        <h1 class="m-4 text-4xl font-bold">
          {{ displayName }}
        </h1>
      </div>
      <LoginGoogle />
      <LoginApp />
      <div class="divider m-0">
        {{ $t("Or") }}
      </div>
      <LoginEmail />
      <div class="flex items-center gap-2">
        <input v-model="auths.agreed" type="checkbox" class="checkbox">
        <label class="label text-sm whitespace-break-spaces">
          <LoginPolicy />
        </label>
      </div>
    </div>

    <div class="text-xs text-gray-400">
      v{{ version }}
    </div>
  </div>
</template>
