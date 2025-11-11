# build stage
FROM node:22-alpine AS builder
WORKDIR /app

# install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Build arguments
ARG DATABASE_CLIENT
ARG DATABASE_HOST
ARG DATABASE_PORT
ARG DATABASE_NAME
ARG DATABASE_USERNAME
ARG DATABASE_PASSWORD

# Set environment variables from build args
ENV DATABASE_CLIENT=$DATABASE_CLIENT
ENV DATABASE_HOST=$DATABASE_HOST
ENV DATABASE_PORT=$DATABASE_PORT
ENV DATABASE_NAME=$DATABASE_NAME
ENV DATABASE_USERNAME=$DATABASE_USERNAME
ENV DATABASE_PASSWORD=$DATABASE_PASSWORD

# Copy the rest of the app
COPY . .

# Build Strapi
RUN npm run build

# runtime stage
FROM node:22-alpine AS runtime
WORKDIR /app

ENV NODE_ENV=production

# Copy built files
COPY --from=builder /app .

# Create uploads folder
RUN mkdir -p /srv/uploads

EXPOSE 1337

CMD ["npm", "start"]
