FROM node:18-bullseye

# Set working directory inside container
WORKDIR /usr/src/app

# Copy package.json only to leverage Docker cache
COPY package.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy the rest of the application
COPY . .

# Accept TMDB API key from build argument and set as environment variable
ARG TMDB_API_KEY
ENV TMDB_KEY=$TMDB_API_KEY

# Build the Next.js application
RUN npm run build

# Expose the port the app will run on
EXPOSE 3000

# Command to start the app
CMD ["npm", "start"]
