import { defineNuxtPlugin } from "#app";
import { App } from "@capacitor/app";
import { Clipboard } from "@capacitor/clipboard";

export default defineNuxtPlugin((nuxtApp) => {
  const plugins = usepluginstore();

  const checkclipboard = async () => {
    try {
      console.warn("clipboard check");
      const { value } = await Clipboard.read();

      if (!value)
        return;

      const postregex = /^https:\/\/www\.example\.com\/posts\/([a-z0-9-]+)$/i;

      let targetpath: string | null = null;

      if (postregex.test(value)) {
        const id = value.match(postregex)?.[1];
        targetpath = `/posts/${id}`;
      }

      if (targetpath && targetpath !== plugins.clipboard.ignore) {
        plugins.clipboard.link = targetpath || "";
        plugins.clipboard.bus++;
      }
    } catch (err) {
      console.error("clipboard error:", err);
    }
  };
  nuxtApp.hook("app:mounted", checkclipboard);

  App.addListener("resume", checkclipboard);
});
