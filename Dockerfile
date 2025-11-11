# =====================
# Build stage
# =====================
FROM node:22-alpine AS builder
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy app source
COPY . .

# Build Strapi
RUN npm run build

# =====================
# Runtime stage
# =====================
FROM node:22-alpine AS runtime
WORKDIR /app

# Set production mode
ENV NODE_ENV=production

# Copy built files from builder
COPY --from=builder /app ./

# Create uploads folder
RUN mkdir -p /srv/uploads

# Expose port
EXPOSE 1337

# Start Strapi
CMD ["npm", "start"]
