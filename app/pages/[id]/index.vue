<script setup lang="ts">
const user = useSupabaseUser();
const supabase = useSupabaseClient();
const profiles = useprofilestore();
const { t } = useI18n();

const tab = ref(0);
const id = useRoute().params.id as string;
const bus = ref(0);

const { data } = await supabase
  .from("profiles")
  .select(
    `
    *, 
    titles(*), 
    follows_target_id_fkey(count),
    follows_user_id_fkey(count),
    isfollower:follows_target_id_fkey(count)
    `,
  )
  .eq("id", id)
  .eq("isfollower.user_id", user.value?.id || defaultuuid)
  .single();

if (user.value?.id !== data?.id && !profiles.item?.is_admin) {
  if (!data || data.banned_at)
    useRouter().replace("/404");
}

const { data: firendsnum } = await supabase.rpc("get_friends_number", {
  user_id: id,
});

const [postcount, bookcount, pointcount, starcount] = await Promise.all([
  supabase
    .from("posts")
    .select("id", { count: "exact", head: true })
    .eq("user_id", id)
    .is("post_id", null)
    .is("deleted_at", null)
    .is("is_report", null),
  supabase
    .from("books")
    .select("id", { count: "exact", head: true })
    .eq("user_id", id)
    .is("deleted_at", null),
  supabase
    .from("points")
    .select("id", { count: "exact", head: true })
    .eq("user_id", id)
    .is("deleted_at", null),
  supabase
    .from("likes")
    .select("id", { count: "exact", head: true })
    .eq("user_id", id)
    .not("book_id", "is", null),
]);

const tabs = computed(() => [
  `${t("Posts")} (${postcount.count})`,
  `${t("Books")} (${bookcount.count})`,
  `${t("Points")} (${pointcount.count})`,
  `${t("Stars")} (${starcount.count})`,
]);
</script>

<template>
  <Navbar>
    <AppFrame>
      <AppBar :title="data?.name">
        <AppDots v-if="user?.id !== id" @click="bus++" />
      </AppBar>
      <AppMore :hidden="true" :bus="bus">
        <ProfileReport :id="id" />
        <ProfileBlock :id="id" />
      </AppMore>
      <div class="bg-neutral flex h-[33vw] max-h-56 w-full justify-end p-4" />
      <div class="relative flex h-16">
        <div class="absolute bottom-1/4 left-4 flex">
          <ProfileUpload
            :id="data?.id || ''"
            :url="data?.avatar_url"
            :name="data?.name"
          />
        </div>
        <div class="absolute right-0 bottom-1/4 flex justify-end">
          <div class="flex h-full w-32 items-center justify-end pr-4">
            <ProfileFollow
              :userid="id"
              :isfollow="data?.isfollower[0]?.count"
            />
          </div>
        </div>
      </div>
      <div class="my-2 px-4">
        <div class="flex items-center gap-2">
          <ProfileName id="" class="text-2xl" :name="data?.name" />
          <ProfileTitle
            v-for="(title, index) in data?.titles"
            :key="index"
            :title="title"
            class="badge-lg!"
          />
        </div>
        <div class="flex gap-1">
          <ProfileUid :name="data?.uid" />
          <ProfileUsername :name="data?.username" />
        </div>
        <div class="flex gap-4">
          <ProfileFollowing :number="data?.follows_user_id_fkey[0]?.count" />
          <ProfileFollower :number="data?.follows_target_id_fkey[0]?.count" />
          <ProfileFirend :number="firendsnum || 0" />
        </div>
        <div v-if="data?.banned_at" class="text-warning">
          {{ $t("Banned") }}
        </div>
      </div>
      <div v-if="profiles.item?.is_admin && data" class="flex gap-4 p-4">
        <ProfileBan v-if="!data.banned_at" :id="data.id" />
        <ProfileUnban v-else :id="data.id" />
      </div>
      <AppTab v-model="tab" class="top-st2 sticky" :tabs="tabs" />
      <AppSwiper v-model="tab">
        <swiper-slide>
          <ProfilePosts :id="id" />
        </swiper-slide>
        <swiper-slide>
          <ProfileBooks :id="id" />
        </swiper-slide>
        <swiper-slide>
          <ProfilePoints :id="id" />
        </swiper-slide>
        <swiper-slide>
          <ProfileStars :id="id" />
        </swiper-slide>
      </AppSwiper>
    </AppFrame>
  </Navbar>
</template>
