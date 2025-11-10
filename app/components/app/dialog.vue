<script setup lang="ts">
const props = defineProps<{
  bus: number;
  cancel: () => Promise<void>;
  confirm: () => Promise<void>;
  content: string;
}>();

const my_modal_5: Ref<HTMLDialogElement | null> = ref(null);

watch(
  () => props.bus,
  () => {
    my_modal_5.value?.showModal();
  },
);
</script>

<template>
  <dialog
    ref="my_modal_5"
    class="
      modal modal-bottom
      sm:modal-middle
    "
    @click.stop
  >
    <div class="modal-box">
      <h3 class="text-lg font-bold">
        {{ $t("Hint") }}
      </h3>
      <p v-if="content" class="py-4">
        {{ content }}
      </p>
      <slot />
      <div class="modal-action">
        <form method="dialog" class="flex w-full items-center justify-evenly">
          <button class="btn px-6" @click="cancel">
            {{ $t("Cancel") }}
          </button>
          <button class="btn btn-primary px-6" @click="confirm">
            {{ $t("Confirm") }}
          </button>
        </form>
      </div>
    </div>
    <form method="dialog" class="modal-backdrop">
      <button class="outline-none">
        close
      </button>
    </form>
  </dialog>
</template>
