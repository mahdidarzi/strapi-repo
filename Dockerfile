# build stage
FROM node:22-alpine AS builder
WORKDIR /app

# Copy package.json only
COPY package.json ./

# Install dependencies
RUN npm install

# Copy rest of the app
COPY . .

# Build the project
RUN npm run build

# runtime stage
FROM node:22-alpine AS runtime
WORKDIR /app

ENV NODE_ENV=production

# Copy build and necessary files
COPY --from=builder /app ./

# Create uploads folder
RUN mkdir -p /srv/uploads

# Expose port
EXPOSE 1337

# Start the app
CMD ["npm", "start"]
