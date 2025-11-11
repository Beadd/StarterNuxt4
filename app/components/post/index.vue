<script setup lang="ts">
const props = defineProps<{
  post: typepost;
}>();

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const profiles = useprofilestore();
const toast = useToast();
const { t } = useI18n();

async function add() {
  const { error } = await supabase
    .from("likes")
    .insert({ post_id: props.post?.id });
  if (error)
    showtoasterror(toast, t);
}

async function remove() {
  const { error } = await supabase
    .from("likes")
    .delete()
    .match({ post_id: props.post?.id });
  if (error)
    showtoasterror(toast, t);
}

function click() {
  useRouter().push(`/posts/${props.post?.id}`);
}
</script>

<template>
  <div
    :class="{ 'bg-secondary/20': post?.isnew }"
    class="border-neutral bg-neutral/30 cursor-pointer border-b px-4 py-2"
    @click="click"
  >
    <div class="flex">
      <div class="flex py-2">
        <div class="flex w-16 items-start justify-start">
          <ProfileAvatar
            :id="post?.profiles?.id || ''"
            :url="post?.profiles?.avatar_url"
            :name="post?.profiles?.name"
          />
        </div>
      </div>
      <div class="flex w-full flex-col gap-1">
        <div class="relative mt-2 flex items-start justify-between">
          <div class="flex flex-wrap items-baseline gap-1">
            <ProfileName
              :id="post?.profiles?.id || ''"
              :name="post?.profiles?.name"
            />
            <ProfileTitle
              v-for="(title, index) in post?.profiles?.titles"
              :key="index"
              :title="title"
            />
            <ProfileUid :name="post?.profiles?.uid" />
          </div>
          <AppMore>
            <PostDel v-if="post?.user_id === user?.id" :post="post" />
            <div v-else>
              <PostReport :post="post" />
              <PostBlock :post="post" />
            </div>
          </AppMore>
        </div>
        <PostContent :post="post" />
        <AppDate :date="post?.created_at || ''" />
        <div v-if="post.banned_at" class="text-warning">
          {{ $t("Banned") }}
        </div>
      </div>
    </div>
    <div class="flex items-center justify-around">
      <AppComment :count="post?.posts[0]?.count || 0" />
      <AppLike
        :count="post?.likes[0]?.count"
        :liked="post?.is_liked[0]?.count || 0 > 0"
        :add="add"
        :remove="remove"
      />
      <AppShare :path="`posts/${post.id}`" />
    </div>
  </div>
  <div v-if="profiles.item?.is_admin" class="flex gap-4 p-4">
    <PostBan v-if="!post.banned_at" :id="post.id" />
    <PostUnban v-else :id="post.id" />
  </div>
  <PostBook :post="post" />
  <PostSub v-for="sub in post.subs" :key="sub.id" :sub="sub" />
</template>
