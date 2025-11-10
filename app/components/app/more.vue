<script setup lang="ts">
defineOptions({ inheritAttrs: false });

const props = defineProps<{
  bus?: number;
  hidden?: boolean;
}>();

const modal = ref<HTMLDialogElement | null>(null);

watch(
  () => props.bus,
  () => {
    modal.value?.showModal();
  },
);
</script>

<template>
  <AppDots
    v-if="!hidden"
    v-bind="$attrs"
    class="absolute -top-4 -right-4"
    @click.stop
    @click="modal?.showModal()"
  />
  <dialog
    ref="modal" class="
      modal modal-bottom
      sm:modal-middle
    " @click.stop
  >
    <div
      class="
        modal-box p-0
        max-sm:pb-16
      "
    >
      <form method="dialog">
        <slot />
      </form>
    </div>
    <form method="dialog" class="modal-backdrop">
      <button class="outline-none">
        close
      </button>
    </form>
  </dialog>
</template>
