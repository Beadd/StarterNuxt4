<script setup lang="ts">
const supabase = useSupabaseClient();
const router = useRouter();
const toast = useToast();
const { t } = useI18n();

const name = ref("");
const username = ref("");
const hastoken = ref(false);
const id = useRoute().params.id as string;

const { data } = await supabase
  .from("profiles")
  .select("name, username")
  .eq("id", id)
  .single();

name.value = data?.name || "";
username.value = data?.username || "";

async function load() {
  if (!name.value) {
    showtoastcheckform(toast, t);
    return;
  }

  const { error } = await supabase
    .from("profiles")
    .update({
      name: name.value,
      username: username.value,
    })
    .match({
      id,
    });

  if (!error) {
    showtoastsuccess(toast, t);
    router.push(`/id/${id}`);
  } else {
    hastoken.value = true;
    showtoast(toast, t("Username is already taken"), "error");
  }
}
</script>

<template>
  <Navbar>
    <AppFrame>
      <AppBar :title="$t('Edit profile')" />
      <div class="flex flex-col p-4">
        <fieldset class="fieldset">
          <legend class="fieldset-legend">
            {{ $t("Display name") }}
          </legend>
          <AppInput>
            <i class="bx bx-rename" />
            <input v-model="name" :placeholder="$t('Display name')">
          </AppInput>
        </fieldset>
        <fieldset class="fieldset">
          <legend class="fieldset-legend">
            {{ $t("Username") }}
          </legend>
          <AppInput :error="hastoken">
            <i class="bx bx-key" />
            <input
              v-model="username"
              :placeholder="$t('Username')"
              @input="hastoken = false"
            >
          </AppInput>
          <p class="fieldset-label">
            {{ $t("Optional") }}
          </p>
        </fieldset>
        <div class="flex justify-end">
          <AppBtn :load="load" class="btn-primary px-6">
            {{ $t("Save") }}
          </AppBtn>
        </div>
      </div>
    </AppFrame>
  </Navbar>
</template>
