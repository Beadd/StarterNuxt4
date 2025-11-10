<script setup lang="ts">
const props = defineProps<{
  warning?: boolean;
  accept: {
    [mime: string]: string[];
  };
  dataType?: "Text" | "ArrayBuffer" | "Blob";
}>();

const model = defineModel<string | ArrayBuffer | Blob>();
const size = defineModel<number>("size");

const { data, fileName, open } = useFileSystemAccess({
  dataType: props.dataType || "Text",
  types: [
    {
      accept: props.accept,
    },
  ],
});

async function click() {
  await open();
  if (data.value) {
    model.value = data.value;

    if (data.value instanceof ArrayBuffer) {
      size.value = data.value.byteLength;
    } else if (data.value instanceof Blob) {
      size.value = data.value.size;
    } else if (typeof data.value === "string") {
      size.value = new TextEncoder().encode(data.value).length;
    }
  }
}

function formatsize(size: number) {
  if (size < 1024)
    return `${size} B`;
  if (size < 1024 * 1024)
    return `${(size / 1024).toFixed(2)} KB`;
  return `${(size / 1024 / 1024).toFixed(2)} MB`;
}
</script>

<template>
  <div
    class="
      flex w-full cursor-pointer flex-col items-center justify-center
      overflow-hidden rounded-xl border-2 p-2 text-center
    "
    :class="
      props.warning
        ? 'bg-warning/50 border-warning text-warning'
        : 'bg-secondary/30 border-secondary text-secondary'
    "
    @click="click"
  >
    <div class="flex items-center justify-center gap-2">
      <i class="bx bxs-file-plus" />
      {{ fileName || $t("Choose a file") }}
      <span v-if="size" class="mt-1 text-xs opacity-70">
        {{ formatsize(size) }}
      </span>
    </div>
  </div>
</template>
