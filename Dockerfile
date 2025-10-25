# Base image
FROM node:18-bullseye

# Set working directory
WORKDIR /app

# Copy package files first for caching dependencies
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy the rest of the app
COPY . .

# Expose the port the app will run on
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
