# build stage
FROM node:22-alpine AS builder
WORKDIR /app

# install pnpm (if you use pnpm) or use npm
RUN corepack enable && corepack prepare pnpm@8.8.0 --activate

COPY package.json pnpm-lock.yaml* ./
# copy backend code
COPY . .

RUN pnpm install --frozen-lockfile
RUN pnpm build

# runtime stage
FROM node:22-alpine AS runtime
WORKDIR /app

ENV NODE_ENV=production
# copy only what's needed
COPY --from=builder /app ./

# create uploads folder
RUN mkdir -p /srv/uploads

# expose port
EXPOSE 1337

# safe start
CMD ["pnpm", "start"]
