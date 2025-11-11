<script setup>
const { locales, setLocale, locale } = useI18n();

function change(event) {
  setLocale(event.target.value);
}
</script>

<template>
  <div class="flex flex-col gap-4 p-4">
    {{ $t("Language") }}
    <app-select
      v-model="locale"
      :options="locales.map((l) => ({ label: l.name, value: l.code }))"
      @change="change"
    />
  </div>
</template>
