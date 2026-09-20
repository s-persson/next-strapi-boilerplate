FROM node:24-alpine
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git
ARG NODE_ENV
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY strapi/package.json ./
RUN npm install -g node-gyp
RUN npm config set fetch-retry-maxtimeout 600000 -g && npm install
ENV PATH /opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY strapi/ .
RUN chown -R node:node /opt/app
USER node
RUN ["npm", "run", "build"]

# EXTRA VITE STUFF HERE
# switch back to root to make node:node owner of node_modules after build
USER root
RUN mkdir -p /opt/app/node_modules && chown node:node /opt/app/node_modules
# switch back to node user to create vite writeable directory
USER node
RUN mkdir -p /opt/app/node_modules/.strapi/vite

EXPOSE 1337
CMD ["npm", "run", "start"]
