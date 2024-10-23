# syntax = docker/dockerfile:1

ARG NODE_VERSION=23.0.0

FROM node:${NODE_VERSION}-bullseye-slim AS base
WORKDIR /app

FROM base AS development
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=~/.npm,sharing=locked npm ci
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]

FROM base AS production-deps
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=~/.npm,sharing=locked npm ci --omit=dev

FROM base AS build
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=~/.npm,sharing=locked npm ci
COPY . .
RUN npm run build

FROM base AS production
COPY --from=production-deps /app/node_modules /app/node_modules
COPY --from=build /app/.next /app/.next
COPY --from=build /app/package.json /app/package.json
EXPOSE 3000
USER node
CMD ["npm", "run", "start"]
