<template>
  <div class="flex items-center justify-center">
    <div
      :class="$attrs.class"
      class="
        border-neutral max-w-x min-h-dvh w-full border-x px-px
        max-md:border-none
      "
    >
      <slot />
    </div>
  </div>
</template>
