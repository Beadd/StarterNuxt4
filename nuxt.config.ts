import tailwindcss from "@tailwindcss/vite";

export default defineNuxtConfig({
  // ssr: false,
  compatibilityDate: "2025-07-15",
  devtools: { enabled: true },
  typescript: {
    typeCheck: true,
  },
  css: ["./app/assets/css/main.css"],
  vite: {
    plugins: [tailwindcss()],
  },
  modules: [
    "@pinia/nuxt",
    "pinia-plugin-persistedstate",
    "@nuxtjs/i18n",
    "@nuxt/eslint",
    "@primevue/nuxt-module",
    "@vueuse/nuxt",
    "@nuxtjs/supabase",
    "nuxt-swiper",
  ],
  i18n: {
    defaultLocale: "zh",
    strategy: "no_prefix",
    locales: [
      { code: "zh", name: "简体中文", file: "zh.json" },
      { code: "en", name: "English", file: "en.json" },
      { code: "ja", name: "日本語", file: "ja.json" },
    ],
  },
  supabase: {
    redirect: false,
    types: "../../../../database.types.ts",
  },
  eslint: {
    checker: true,
  },
});
