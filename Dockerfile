# Use Node 18 as base image
FROM node:18-bullseye

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy the rest of the app
COPY . .

# Expose the app port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
