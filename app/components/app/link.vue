<script setup lang="ts">
const props = defineProps<{
  link: string;
  bus: number;
}>();

async function copy() {
  navigator.clipboard.writeText(props.link);
}
</script>

<template>
  <app-dialog
    :bus="bus"
    :confirm="async () => {}"
    :cancel="async () => {}"
    :content="
      $t(
        'You can share this link, copy it and open it in a browser or within the app to jump to this article',
      )
    "
  >
    <div class="flex flex-col gap-4">
      <div class="flex">
        <app-input>
          <input :placeholder="link" disabled>
        </app-input>
        <app-btn class="btn-primary rounded-xl" :load="copy">
          <i class="bx bxs-copy" />
        </app-btn>
      </div>
      <span class="text-sm opacity-50">
        {{
          $t("Automatically copied. If it didn't work, please copy manually")
        }}
      </span>
    </div>
  </app-dialog>
</template>
