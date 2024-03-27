<template>
  <div class="radio">
    <p style="font-size: 110%; padding: 10px; padding-bottom: 0; text-align: center;">
      <b>Cutiemarx FM</b>
    </p>
    <div style="height: 52px">
      <ClientOnly>
        <VuePlyr class="radio-player" :options="{ invertTime: false, controls: ['play', 'current-time', 'mute', 'volume'] }">
          <audio crossorigin playsinline>
            <source :src="station + 'main.mp3'" type="audio/mp3" />
          </audio>
        </VuePlyr>
      </ClientOnly>
    </div>

    <p v-if="artist || title" style="padding: 10px; padding-top: 0; text-align: center;">
      <b><i>Currently playing:</i></b>
      {{ artist }} - {{ title }}
    </p>
    <p v-else style="padding: 10px; padding-top: 0; text-align: center;">
      <b><i>loading station...</i></b>
    </p>
  </div>
</template>

<script lang="ts" setup>
import VuePlyr from "vue-plyr";
import "vue-plyr/dist/vue-plyr.css";

interface Props {
  station: string;
}
const props = defineProps<Props>();

interface StatusJsonResponse {
  icestats: Station;
}
interface Station {
  admin: string;
  banned_IPs: number;
  build: number;
  host: string;
  location: string;
  outgoing_kbitrate: number;
  server_id: string;
  server_start: string;
  stream_kbytes_read: number;
  stream_kbytes_sent: number;
  source: Endpoint[];
}
interface Endpoint {
  artist: string;
  audio_info: string;
  bitrate: number;
  connected: number;
  genre: string;
  incoming_bitrate: number;
  listener_peak: number;
  listeners: number;
  listenurl: string;
  metadata_updated: string;
  outgoing_kbitrate: number;
  queue_size: number;
  server_name: string;
  server_type: string;
  server_url: string;
  stream_start: string;
  title: string;
  total_mbytes_sent: number;
  yp_currently_playing: string;
}

const { data, error, pending, refresh } = useLazyFetch<StatusJsonResponse>(() => props.station + "status-json.xsl", {
  server: false,
});

useIntervalFn(() => {
  refresh();
}, 3000);

const endpoints = computed(() => {
  return data.value?.icestats.source ?? [];
});
const endpoint = computed(() => endpoints.value.find((endpoint) => endpoint.bitrate === 192));

const artist = computed(() => endpoint.value?.artist);
const title = computed(() => endpoint.value?.title);
</script>

<style scoped>
.radio {
  border: solid 1px var(--elements-surface-secondary-backgroundColor);
  border-radius: var(--radii-md);
  overflow: hidden;

  --plyr-color-main: var(--color-primary-500);
  --plyr-audio-controls-background: var(--alpine-body-backgroundColor);
  --plyr-audio-control-color: var(--alpine-body-color);
  --plyr-audio-control-color-hover: var(--alpine-body-backgroundColor);
}
</style>

