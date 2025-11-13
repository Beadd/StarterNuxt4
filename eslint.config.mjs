import antfu from "@antfu/eslint-config";
import vueI18n from "@intlify/eslint-plugin-vue-i18n";
import eslintPluginBetterTailwindcss from "eslint-plugin-better-tailwindcss";
import eslintParserVue from "vue-eslint-parser";

export default antfu(
  {
    stylistic: {
      indent: 2,
      quotes: "double",
      semi: true,
    },
  },
  {
    rules: {
      "style/brace-style": ["error", "1tbs"],
    },
  },
  {
    ignores: ["database.types.ts", "android", "ios", "public"],
  },
  {
    files: ["**/*.vue"],
    languageOptions: {
      parser: eslintParserVue,
    },
  },
  {
    plugins: {
      "better-tailwindcss": eslintPluginBetterTailwindcss,
    },
    rules: {
      "better-tailwindcss/enforce-consistent-line-wrapping": [
        "warn",
        { printWidth: 100 },
      ],
    },
    settings: {
      "better-tailwindcss": {
        entryPoint: "app/assets/css/main.css",
      },
    },
  },
  ...vueI18n.configs.recommended,
  {
    rules: {
      "@intlify/vue-i18n/no-dynamic-keys": "error",
      "@intlify/vue-i18n/no-unused-keys": [
        "error",
        {
          extensions: [".js", ".vue", ".ts"],
        },
      ],
      "@intlify/vue-i18n/no-raw-text": ["error", {
        ignoreText: ["@", "#", "$", ".", 'v'],
      }],
    },
    settings: {
      "vue-i18n": {
        localeDir: "i18n/locales/*.{json,json5,yaml,yml}",
        messageSyntaxVersion: "^11.0.0",
      },
    },
  },
);
