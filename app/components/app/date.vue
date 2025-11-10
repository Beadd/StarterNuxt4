<script setup lang="ts">
import { formatDistance, formatRelative, isValid, parseISO } from "date-fns";

const props = defineProps<{
  date: string;
  trigger?: boolean;
}>();

const { locale } = useI18n();

const parsed = computed(() => {
  const d = parseISO(props.date);
  return isValid(d) ? d : null;
});
</script>

<template>
  <div v-if="parsed" class="text-sm opacity-50">
    <span v-if="trigger">
      {{ formatRelative(parsed, new Date(), { locale: getfnslocal(locale) }) }}
    </span>
    <span v-else>
      {{ formatDistance(parsed, new Date(), { locale: getfnslocal(locale) }) }}
    </span>
  </div>
  <div v-else class="text-sm italic opacity-50">
    Invalid date
  </div>
</template>
