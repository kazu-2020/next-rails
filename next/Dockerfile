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
