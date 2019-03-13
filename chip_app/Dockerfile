FROM node as build_deps
WORKDIR /usr/src/app
COPY . ./
RUN yarn upgrade
RUN yarn global add elm elm-test
RUN yarn
RUN yarn build

FROM nginx
COPY --from=build_deps /usr/src/app/build /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# FROM node
# WORKDIR /app
# COPY . ./
# RUN yarn upgrade
# RUN yarn global add elm elm-test
# RUN yarn
# EXPOSE 80
# CMD ["yarn", "start"]