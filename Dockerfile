# Build stage
FROM node:18-alpine as build-stage
WORKDIR /app

ADD . .

# Install the node modules and build the project
RUN yarn install --prefer-offline --frozen-lockfile --non-interactive && \
    yarn build

# Production stage
FROM node:18-alpine
WORKDIR /var/www/html

COPY --from=build-stage /app/.output .
CMD ["node", "./server/index.mjs"]