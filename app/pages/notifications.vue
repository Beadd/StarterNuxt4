<script setup lang="ts">
const user = useSupabaseUser();
const supabase = useSupabaseClient();
const toast = useToast();
const loading = useloadingstore();
const notifications = usenotificationstore();
const { t } = useI18n();

const more = ref(true);
const last = ref<string | null>(null);
const bus = ref(0);

notifications.list = [];

async function load() {
  if (!user.value)
    return;

  let query = supabase
    .from("notifications")
    .select(
      `
      *,
      profiles(*)
    `,
    )
    .eq("receiver_id", user.value.id)
    .order("created_at", { ascending: false })
    .limit(10);

  if (last.value) {
    query = query.lt("created_at", last.value);
  }

  const { data } = await query;
  if (!data) {
    more.value = false;
    return;
  }

  if (data.length < 10)
    more.value = false;

  last.value = data[data.length - 1]?.created_at || null;
  notifications.list.push(...data);
}

async function confirm() {
  loading.trigger = true;

  const { error } = await supabase
    .from("notifications")
    .update({
      is_read: true,
    })
    .match({
      receiver_id: user.value?.id,
    });

  if (!error) {
    notifications.list = notifications.list.map(notification => ({
      ...notification,
      is_read: true,
    }));
    notifications.number = 0;

    showtoastsuccess(toast, t);
    loading.trigger = false;
  }
}
</script>

<template>
  <Navbar :dock="true">
    <AppFrame>
      <AppBar :title="$t('Notifications')" :show="true">
        <div
          class="flex h-full cursor-pointer items-center justify-center font-bold select-none"
          @click="bus++"
        >
          {{ $t("Clear") }}
        </div>
      </AppBar>
      <AppDialog
        :bus="bus"
        :confirm="confirm"
        :content="$t('Confirm marking as read')"
        :cancel="async () => {}"
      />
      <Notification
        v-for="notification in notifications.list"
        :key="notification.id"
        :notification="notification"
      />
      <AppLoadder :load="load" :more="more" />
    </AppFrame>
  </Navbar>
</template>
