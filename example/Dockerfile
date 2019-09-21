FROM node:12.10-alpine AS builder

WORKDIR /build

COPY package.json yarn.lock /build/

RUN yarn install --production
RUN yarn build-for-prod

FROM 4ops/static

COPY --from=builder /build/public /content
