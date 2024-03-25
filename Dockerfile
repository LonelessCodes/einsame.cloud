ARG NODE_VERSION=20.11

FROM node:${NODE_VERSION}-slim as base

WORKDIR /src

COPY --link package.json package-lock.json ./

# Build
FROM base as build

RUN npm install

COPY --link . .

ARG NUXT_PUBLIC_STUDIO_TOKENS
RUN NUXT_PUBLIC_STUDIO_TOKENS=$NUXT_PUBLIC_STUDIO_TOKENS npm run build

# Run
FROM base

ENV PORT=3000
ENV NODE_ENV=production

COPY --from=build /src/.output /src/.output
# Optional, only needed if you rely on unbundled dependencies
# COPY --from=build /src/node_modules /src/node_modules
RUN npm install --omit=dev

CMD [ "node", ".output/server/index.mjs" ]
