# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies (dev + prod)
RUN npm ci

# Copy rest of the source code
COPY . .

# Build Next.js app
RUN npm run build

# Stage 2: Production image
FROM node:20-alpine
WORKDIR /app

# Copy only production dependencies from builder
COPY package*.json ./
RUN npm ci --omit=dev

# Copy built app
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./

# Expose port and start
EXPOSE 3000
CMD ["npm", "start"]
