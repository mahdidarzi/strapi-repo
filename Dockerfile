# build stage
FROM node:22-alpine AS builder
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies with npm
RUN npm ci

# Copy the rest of the backend code
COPY . .

# Build the project
RUN npm run build

# runtime stage
FROM node:22-alpine AS runtime
WORKDIR /app

ENV NODE_ENV=production

# Copy only what's needed from builder
COPY --from=builder /app ./

# Create uploads folder
RUN mkdir -p /srv/uploads

# Expose port
EXPOSE 1337

# Start the app
CMD ["npm", "start"]
