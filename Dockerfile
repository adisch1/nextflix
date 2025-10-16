# Use official Node image
FROM node:18.0.0-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy only package.json
COPY package.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy the rest of the application
COPY . .

# Accept TMDB API key as build argument and set environment variable
ARG TMDB_API_KEY
ENV TMDB_KEY=$TMDB_API_KEY

# Build the Next.js app
RUN npm run build

# Expose port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
