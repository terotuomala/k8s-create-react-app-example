FROM node:14-alpine AS base

COPY package*.json ./

RUN npm ci

COPY . .


FROM base AS build

RUN apk update && apk add curl bash && rm -rf /var/cache/apk/*

# Install node-prune (https://github.com/tj/node-prune)
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin

RUN npm run build

# Remove development dependencies
RUN npm prune --production

# Run node prune
RUN /usr/local/bin/node-prune


FROM node:14-alpine AS release

# Switch to non-root user uid=1000(node)
USER node

WORKDIR /home/node

# Set global dependencies directory to node user
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

# Set node loglevel
ENV NPM_CONFIG_LOGLEVEL warn

# Install serve to /home/node/.npm-global/bin/serve directory
RUN npm i -g serve

COPY --chown=node:node --from=build /build ./build
COPY --chown=node:node --from=build /serve.json ./build

EXPOSE 3000

CMD ["/home/node/.npm-global/bin/serve", "-s", "build", "-c", "serve.json", "-l", "3000", "-n"]


