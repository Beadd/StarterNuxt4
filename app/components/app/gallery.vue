<script setup lang="ts">
import PhotoSwipeLightbox from "photoswipe/lightbox";
import "photoswipe/style.css";

const props = defineProps<{
  galleryid: string;
  images: {
    largeurl: string;
    thumbnailurl: string;
    width: number;
    height: number;
  }[];
}>();

let lightbox: PhotoSwipeLightbox | null = null;

function click(e: MouseEvent) {
  const target = e.target as HTMLElement;
  const anchor = target.closest("a");

  if (anchor) {
    e.stopPropagation();
  }
}

onMounted(() => {
  if (!lightbox) {
    lightbox = new PhotoSwipeLightbox({
      gallery: `#${props.galleryid}`,
      children: "a",
      pswpModule: () => import("photoswipe"),
      // showAnimationDuration: 0,
      // hideAnimationDuration: 0,
      // zoomAnimationDuration: 0,
    });
    lightbox.init();
  }
});

onUnmounted(() => {
  if (lightbox) {
    lightbox.destroy();
    lightbox = null;
  }
});
</script>

<template>
  <div
    :id="galleryid"
    class="grid gap-2"
    :class="{
      'grid-cols-2': images.length === 2 || images.length === 4,
      'grid-cols-3': images.length === 3 || images.length >= 5,
    }"
    @click="click"
  >
    <a
      v-for="(image, key) in images"
      :key="key"
      :href="image.largeurl"
      :data-pswp-width="image.width"
      :data-pswp-height="image.height"
      target="_blank"
      rel="noreferrer"
      class="flex"
    >
      <img
        :src="image.thumbnailurl"
        alt=""
        class="h-full w-full object-cover"
      >
    </a>
  </div>
</template>
