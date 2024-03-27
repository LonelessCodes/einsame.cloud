export default defineNuxtConfig({
  // https://github.com/nuxt-themes/alpine
  extends: "@nuxt-themes/alpine",

  modules: [
    "@nuxtjs/plausible",
    "@nuxt/devtools",
    "@nuxthq/studio",
    "@vueuse/nuxt",
  ],

  devtools: {
    enabled: true,
  },
});

