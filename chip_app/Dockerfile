FROM node
WORKDIR /app
COPY . /app
RUN yarn upgrade
RUN yarn global add elm elm-test nodemon
RUN yarn
# MASTER
EXPOSE 3000
# DEV
# EXPOSE 3002
CMD ["yarn", "start"]