#!/usr/bin/env sh

# abort on errors
set -e

# SvelteKit scaffold
npx sv create tax-tool
# ┌  Welcome to the Svelte CLI (v0.9.2)
# │
# ◇  Which template would you like?
# │  SvelteKit minimal
# │
# ◇  Add type checking with TypeScript?
# │  No
# │
# ◇  What would you like to add to your project?
# │  tailwindcss, sveltekit-adapter
# │
# ◇  tailwindcss: Which plugins would you like to add?
# │  forms
# │
# ◇  sveltekit-adapter: Which SvelteKit adapter would you like to use?
# │  static
# │
# ◇  Which package manager do you want to install dependencies with?
# │  bun

cd tax-tool

bun install currency.js
# https://currency.js.org/
# library to solve common floating point issues in js
# use for decimals and any arithmitic involving decimals

# configure decimal precision value in all calls involving rates
# otherwise rates involving more than 2 decimal points will be falsely rounded

# to test in development
# bun run dev --open

# create server file
touch ./src/routes/+layout.server.js

# add to prerender SSR content to SSG
echo "export const prerender = true;" > ./src/routes/+layout.server.js

# to build for production
bun run build
