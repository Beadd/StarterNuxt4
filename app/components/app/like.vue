<script setup lang="ts">
const props = defineProps<{
  add: () => Promise<void>;
  remove: () => Promise<void>;
}>();
const count: Ref = defineModel("count");
const liked: Ref = defineModel("liked");

const user = useSupabaseUser();
const button = ref(null);
const hovered = useElementHover(button);
const animate = ref(false);

async function click() {
  if (!user.value)
    useRouter().push("/login");

  if (liked.value) {
    liked.value = false;
    count.value--;

    await props.remove();
  } else {
    liked.value = true;
    count.value++;
    animate.value = true;
    setTimeout(() => {
      animate.value = false;
    }, 1000);

    await props.add();
  }
}
</script>

<template>
  <button
    ref="button"
    class="flex cursor-pointer items-center justify-center"
    :class="[hovered || liked ? 'text-error' : '', liked ? '' : 'opacity-70']"
    @click.stop
    @click="click"
  >
    <i
      :class="[
        hovered ? 'bg-error/30' : '',
        liked ? 'bxs-heart' : 'bx-heart',
        { 'bx-tada': animate },
      ]"
      class="bx rounded-full p-3 transition-all duration-200 ease-linear"
    />
    <span class="text-sm">{{ count }}</span>
  </button>
</template>
