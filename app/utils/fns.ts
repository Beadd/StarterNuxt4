import { enUS, ja, zhCN } from "date-fns/locale";

export function getfnslocal(locale: string) {
  const base = locale.split("-")[0];
  switch (base) {
    case "zh":
      return zhCN;
    case "ja":
      return ja;
    case "en":
    default:
      return enUS;
  }
}
