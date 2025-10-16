# Use official Node Alpine image
FROM node:18.0.0-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy only package files first (for caching)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps

# Copy the rest of the app
COPY . .

# Set Node options for legacy OpenSSL
ENV NODE_OPTIONS=--openssl-legacy-provider

# API key from build argument
ARG API_KEY
ENV TMDB_KEY=${API_KEY}

# Build the app
RUN npm run build

# Expose port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
