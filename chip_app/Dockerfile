FROM node:11 as build_deps
WORKDIR /usr/src/app
COPY . ./
RUN yarn upgrade && yarn global add elm elm-test && yarn && yarn build

FROM nginx
COPY --from=build_deps /usr/src/app/build /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# FROM node:11
# WORKDIR /app
# COPY . ./
# RUN yarn upgrade && yarn global add elm elm-test && yarn
# EXPOSE 80
# CMD ["yarn", "start"]