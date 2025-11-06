import antfu from "@antfu/eslint-config";
// import css from "@eslint/css";
// import { tailwindSyntax } from "@eslint/css/syntax";
import eslintPluginReadableTailwind from "eslint-plugin-readable-tailwind";
import eslintParserVue from "vue-eslint-parser";

export default antfu(
  {
    stylistic: {
      indent: 2, // 4, or 'tab'
      quotes: "double", // or 'single'
      semi: true,
    },
  },
  {
    rules: {
      "style/brace-style": ["error", "1tbs"],
    },
  },
  // {
  //   files: ["**/*.css"],
  //   plugins: {
  //     css,
  //   },
  //   language: "css/css",
  //   languageOptions: {
  //     customSyntax: tailwindSyntax,
  //   },
  //   rules: {
  //     "css/no-empty-blocks": "error",
  //   },
  // },
  {
    files: ["**/*.vue"],
    languageOptions: {
      parser: eslintParserVue,
    },
  },
  {
    plugins: {
      "readable-tailwind": eslintPluginReadableTailwind,
    },
    rules: {
      // enable all recommended rules to warn
      ...eslintPluginReadableTailwind.configs.warning.rules,
      // enable all recommended rules to error
      ...eslintPluginReadableTailwind.configs.error.rules,

      // or configure rules individually
      "readable-tailwind/multiline": ["warn", { printWidth: 80 }],
    },
  },
  settings: {
      "better-tailwindcss": {
        // tailwindcss 4: the path to the entry file of the css based tailwind config (eg: `src/global.css`)
        entryPoint: "app/assets/css/main.css",
      }
    }
  {
    ignores: ["database.types.ts", "android", "ios", "public"],
  },
);
