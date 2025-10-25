# Use slim Node image to reduce size
FROM node:18-slim

# Set working directory
WORKDIR /app

# Copy only package files first to leverage caching
COPY package*.json ./

# Install dependencies with offline preference
RUN npm ci --legacy-peer-deps --prefer-offline

# Copy rest of the app
COPY . .

# Expose app port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
