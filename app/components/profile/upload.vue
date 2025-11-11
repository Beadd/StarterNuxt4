<script setup lang="ts">
const props = defineProps<{
  url?: string | null;
  name?: string | null;
  id: string;
}>();

const user = useSupabaseUser();
const loading = useloadingstore();
const supabase = useSupabaseClient();
const toast = useToast();
const { t } = useI18n();

const src = ref("");
const files = ref();

onMounted(async () => {
  if (props.url) {
    src.value = await downloadimage(props.url);
  }
});

async function upload(evt: Event) {
  const target = evt.target as HTMLInputElement;
  files.value = target.files;

  try {
    loading.trigger = true;

    if (!files.value || files.value.length === 0) {
      showtoasterror(toast, t);
    }

    const file = files.value[0];
    const ext = file.name.split(".").pop();
    const path = `${uuid()}.${ext}`;

    const { error: uploadError } = await supabase.storage
      .from("avatars")
      .upload(path, file);

    if (uploadError)
      throw uploadError;

    if (user.value) {
      await supabase
        .from("profiles")
        .update({
          avatar_url: path,
        })
        .eq("id", user.value.id);

      src.value = "";
      src.value = await downloadimage(path);
    }
  } finally {
    loading.trigger = false;
  }
}
</script>

<template>
  <div class="avatar avatar-placeholder">
    <div
      class="ring-base-100 bg-neutral text-neutral-content w-32 rounded-full ring-3"
    >
      <img v-if="src" :src="src" alt="Avatar">
      <span v-else class="text-3xl">{{
        name?.charAt(0) || $t("Email user").charAt(0)
      }}</span>
    </div>
    <input
      v-if="user?.id === id"
      class="absolute z-10 size-32 rounded-full opacity-0"
      type="file"
      accept="image/*"
      @change="upload"
    >
  </div>
</template>
