import { App } from "@capacitor/app";
import { LocalNotifications } from "@capacitor/local-notifications";

export default defineNuxtPlugin((nuxtApp) => {
  const user = useSupabaseUser();
  const supabase = useSupabaseClient();
  const notifications = usenotificationstore();
  const profiles = useprofilestore();
  const $t = nuxtApp.vueApp.config.globalProperties.$t;

  let subscription: ReturnType<typeof supabase.channel> | null = null;

  LocalNotifications.requestPermissions();

  const link = async () => {
    if (!user.value)
      return;

    const { data } = await supabase
      .from("notifications")
      .select("count")
      .eq("receiver_id", user.value?.id)
      .not("is_read", "is", true)
      .single();

    notifications.number = data?.count || 0;

    if (subscription) {
      supabase.removeChannel(subscription);
    }

    subscription = supabase
      .channel("custom-insert-channel")
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "notifications",
          filter: `receiver_id=eq.${user.value?.id}`,
        },
        async (payload) => {
          notifications.number++;
          notifications.list.unshift(payload.new as typenotification);
          const notif = getnotifications(payload.new as typenotification, $t);

          await LocalNotifications.schedule({
            notifications: [
              {
                id: Math.floor(Date.now() / 1000),
                title: notif.title || "",
                body: notif.content || "",
                schedule: { at: new Date(Date.now() + 500) },
              },
            ],
          });
        },
      )
      .subscribe();
  };

  watch(
    user,
    async (newval, oldval) => {
      if (user.value && newval?.id !== oldval?.id) {
        const { data: dataprofile } = await supabase
          .from("profiles")
          .select("*, titles(*)")
          .eq("id", user.value?.id || "")
          .single();

        profiles.item = dataprofile || undefined;

        link();
      }
    },
    { immediate: true },
  );

  App.addListener("pause", () => {
    if (subscription) {
      console.warn("remove subscription");

      supabase.removeChannel(subscription);
      subscription = null;
    }
  });

  App.addListener("resume", () => {
    if (user.value) {
      console.warn("resume subscription");

      link();
    }
  });
});
