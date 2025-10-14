FROM node:20-alpine

WORKDIR /app

# Only copy package files first (caching layer)
COPY package*.json ./

RUN npm install --production

# Copy the rest of the app
COPY . .

# Expose port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
