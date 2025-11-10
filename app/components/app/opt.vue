<template>
  <div class="menu w-full p-0">
    <ul>
      <li>
        <a class="flex items-center justify-between rounded-none p-0">
          <button class="flex w-full p-4">
            <slot />
          </button>
        </a>
      </li>
    </ul>
  </div>
</template>
