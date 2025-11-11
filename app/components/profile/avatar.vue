<script lang="ts" setup>
defineOptions({
  inheritAttrs: false,
});

const props = defineProps<{
  id?: string;
  url?: string | null;
  name?: string | null;
  prevent?: boolean;
}>();

const src = ref("");

watch(
  () => props.url,
  async () => {
    if (props.url) {
      src.value = await downloadimage(props.url);
    }
  },
  { immediate: true },
);

function click(e: MouseEvent) {
  if (props.prevent) {
    return;
  } else {
    e?.stopPropagation();
  }

  if (props.id)
    window.open(`/id/${props.id}`);
  else useRouter().push(`/login`);
}
</script>

<template>
  <ClientOnly>
    <div class="avatar avatar-placeholder" @click="click">
      <div
        :class="$attrs.class"
        class="bg-neutral text-neutral-content w-12 rounded-full"
      >
        <img v-if="src" :src="src" alt="Avatar">
        <span v-else>{{ name?.charAt(0) || $t("Email user").charAt(0) }}</span>
      </div>
    </div>
  </ClientOnly>
</template>
