FROM alpine:latest as builder

WORKDIR /var/www

RUN apk add --update nodejs npm

COPY package*.json ./

RUN npm ci --silent

COPY . .

RUN npm run build
#################

FROM alpine:latest

WORKDIR /var/www

RUN apk add --update nodejs npm

COPY package*.json ./

RUN npm ci --silent

COPY --from=builder /var/www/dist ./dist

ENTRYPOINT npm run start:prod
