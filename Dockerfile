FROM node:18-alpine as base

FROM base as build

WORKDIR /usr/src/app

COPY package.* ./

RUN npm install

COPY . .

RUN npm run build
RUN npm install --production

FROM base as release

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json

EXPOSE 3000

CMD ["npm", "run", "start:prod"]
