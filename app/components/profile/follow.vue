<script setup lang="ts">
const props = defineProps<{
  userid: string;
}>();
const isfollow = defineModel("isfollow");

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const toast = useToast();
const { t } = useI18n();

async function add() {
  if (user.value) {
    const { error } = await supabase
      .from("follows")
      .insert({ target_id: props.userid });

    if (error) {
      showtoasterror(toast, t);
    } else {
      isfollow.value = true;
    }
  } else {
    useRouter().push("/login");
  }
}

async function remove() {
  if (user.value) {
    const { error } = await supabase
      .from("follows")
      .delete()
      .match({ target_id: props.userid });

    if (error) {
      showtoasterror(toast, t);
    } else {
      isfollow.value = false;
    }
  }
}
</script>

<template>
  <button
    v-if="props.userid === user?.id"
    class="btn btn-outline btn-primary px-6 font-bold"
    @click="useRouter().push(`/id/${userid}/edit`)"
  >
    {{ $t("Edit profile") }}
  </button>
  <AppBtn v-else class="btn-primary px-6" :load="isfollow ? remove : add">
    {{ isfollow ? $t("Unfollow") : $t("Follow") }}
  </AppBtn>
</template>
