FROM node:18-alpine3.18
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY strapi/package.json strapi/package-lock.json ./
RUN npm install -g node-gyp
RUN npm config set fetch-retry-maxtimeout 600000 -g && npm install
ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY strapi/ .
RUN chown -R node:node /opt/app/config /opt/app/src /opt/app/public/uploads /opt/app
USER node

RUN ["npm", "run", "build"]
EXPOSE 1337
CMD ["sh", "-c", "if [ \"$NODE_ENV\" = 'production' ]; then npm run build && npm run start; else npm run develop; fi"]