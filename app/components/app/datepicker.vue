<script setup lang="ts">
import { format, getDaysInMonth, isValid } from "date-fns";

const date = defineModel<Date | null>();

const { locale } = useI18n();

const year = ref<number | null>(null);
const month = ref<number | null>(null);
const day = ref<number | null>(null);

const years = computed(() => {
  const currentyear = new Date().getFullYear();
  return Array.from({ length: 41 }, (_, i) => currentyear - 20 + i).map(
    y => ({ label: y.toString(), value: y }),
  );
});

const months = computed(() => {
  return Array.from({ length: 12 }, (_, i) => ({
    label: format(new Date(2023, i, 1), "MMMM", {
      locale: getfnslocal(locale.value),
    }),
    value: i + 1,
  }));
});

const days = computed(() => {
  if (!year.value || !month.value)
    return [];
  const daysinmonth = getDaysInMonth(new Date(year.value, month.value - 1));
  return Array.from({ length: daysinmonth }, (_, i) => ({
    label: (i + 1).toString(),
    value: i + 1,
  }));
});

watch([year, month, day], () => {
  if (year.value && month.value && day.value) {
    const selected = new Date(year.value, month.value - 1, day.value);
    if (isValid(selected)) {
      date.value = selected;
    } else {
      date.value = null;
    }
  } else {
    date.value = null;
  }
});

watch(
  date,
  (newdate) => {
    if (newdate && isValid(newdate)) {
      year.value = newdate.getFullYear();
      month.value = newdate.getMonth() + 1;
      day.value = newdate.getDate();
    } else {
      year.value = null;
      month.value = null;
      day.value = null;
    }
  },
  { immediate: true },
);
</script>

<template>
  <app-select v-model="year" :options="years" />
  <app-select v-model="month" :options="months" />
  <app-select v-model="day" :options="days" />
</template>
