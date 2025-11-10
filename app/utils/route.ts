import { useRoute } from "vue-router";

export function ispostspath(): boolean {
  const route = useRoute();
  return route.path === "/posts";
}

export function isminepath(): boolean {
  const route = useRoute();
  return route.path === "/mine";
}

export function isnotificationspath(): boolean {
  const route = useRoute();
  return route.path === "/notifications";
}
