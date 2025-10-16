# Use official Node.js 18 Debian-based image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy only package files first (cache npm install)
COPY package*.json ./

# Install dependencies
# npm ci is faster and reliable for CI
RUN npm ci --legacy-peer-deps

# Copy all app files
COPY . .

# Expose default port (adjust if needed)
EXPOSE 3000

# Default command
CMD ["npm", "start"]
