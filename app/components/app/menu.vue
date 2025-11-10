<script setup lang="ts">
defineOptions({ inheritAttrs: false });
</script>

<template>
  <ul class="menu p-0">
    <li>
      <a class="p-4" v-bind="$attrs">
        <slot />
      </a>
    </li>
  </ul>
</template>
