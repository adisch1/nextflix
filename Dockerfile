FROM node:18-alpine

# Install dependencies for building native modules
RUN apk add --no-cache python3 make g++

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

ENV NODE_OPTIONS=--openssl-legacy-provider

ARG API_KEY
ENV TMDB_KEY=${API_KEY}

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
