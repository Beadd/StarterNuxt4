import type { RealtimeChannel, SupabaseClient } from "@supabase/supabase-js";

export function useSupabaseRealtime(
  supabase: SupabaseClient,
  name: string,
  opts: Parameters<RealtimeChannel["on"]>[1],
  callback: Parameters<RealtimeChannel["on"]>[2],
) {
  const channel: RealtimeChannel = supabase.channel(name);

  (channel as any).on("postgres_changes", opts, callback).subscribe();

  onUnmounted(() => supabase.removeChannel(channel));

  return channel;
}
