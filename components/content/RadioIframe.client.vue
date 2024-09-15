<!-- eslint-disable vue/html-self-closing -->
<template>
  <div>
    <iframe
      ref="iframe"
      :src="`https://${station}/embed?theme=${colorMode.value}`"
      frameborder="0"
      scrolling="no"
    ></iframe>
  </div>
</template>

<script lang="ts" setup>
interface Props {
  station: string;
}
defineProps<Props>();

const colorMode = useColorMode();

const iframe = ref<HTMLIFrameElement>();
const contentWidth = ref<string>("100%");
const contentHeight = ref<string>("120px");

function updateFrameSize() {
  const iframeBody = iframe.value?.contentDocument?.body;
  if (!iframeBody) return;

  console.log(iframeBody.scrollHeight, iframeBody.scrollWidth);
  contentWidth.value = `${iframeBody.scrollWidth}px`;
  contentHeight.value = `${iframeBody.scrollHeight}px`;
}

watch(
  iframe,
  (iframe, _, onCleanup) => {
    const iframeBody = iframe?.contentDocument?.body;
    if (!iframeBody) return;

    const observer = new ResizeObserver(() => {
      updateFrameSize();
    });

    observer.observe(iframeBody);

    iframeBody.addEventListener("load", updateFrameSize);

    onCleanup(() => {
      observer.disconnect();
      iframeBody.removeEventListener("load", updateFrameSize);
    });
  },
  { immediate: true },
);
</script>

<style scoped>
iframe {
  width: v-bind(contentWidth);
  height: v-bind(contentHeight);
}
</style>
