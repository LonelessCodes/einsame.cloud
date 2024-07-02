export default defineNuxtConfig({
  // https://github.com/nuxt-themes/alpine
  extends: "@nuxt-themes/alpine",

  modules: [
    "@nuxt/devtools",
    "@nuxthq/studio",
    "@vueuse/nuxt",
  ],

  devtools: {
    enabled: true,
  },

  routeRules: {
    '/': { prerender: true },
    "/cam": { prerender: true }
  }
});