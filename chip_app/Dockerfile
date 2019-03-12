FROM node
WORKDIR /app
COPY . /app
RUN yarn upgrade
RUN yarn global add elm elm-test
RUN yarn
# MASTER
EXPOSE 3000
# DEV
# EXPOSE 3002
# UAT
# EXPOSE 3030
CMD ["yarn", "start"]