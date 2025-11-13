<script setup lang="ts">
const user = useSupabaseUser();
const router = useRouter();
const route = useRoute();

const allowanonymous = [
  "/login",
  "/confirm",
  "/app",
  /^\/posts\//,
  /^\/id\//,
  /^\/auth\//,
];

function isallowedpath(path: string): boolean {
  return allowanonymous.some(rule =>
    typeof rule === "string" ? rule === path : rule.test(path),
  );
}

router.beforeEach((to) => {
  if (!user.value && !isallowedpath(to.path)) {
    return "/login";
  }
});

onMounted(() => {
  if (!user.value && !isallowedpath(route.path)) {
    router.replace("/login");
  }
});
</script>

<template>
  <slot />
</template>
