export function getnotifications(
  notification: {
    type: string | null;
    title?: string | null;
    content?: string | null;
  },
  t: (key: string) => string,
) {
  const map: Record<
    string,
    { title?: string; content?: string; severity?: string }
  > = {
    welcome: { title: t("Welcome"), content: t("You're all set!") },
    like: { content: t("New like") },
    post: { content: t("New comment") },
    follow: { title: t("Email user"), content: t("New follower") },
    admin: { title: t("Admin message") },
  };

  const mapped = notification.type ? map[notification.type] : undefined;

  return {
    title: mapped?.title || notification.title || "",
    content: mapped?.content || notification.content || "",
    severity: mapped?.severity || "",
  };
}
