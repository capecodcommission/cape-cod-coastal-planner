FROM node
WORKDIR /app
COPY . /app
RUN yarn upgrade
RUN yarn global add elm elm-test
RUN yarn
EXPOSE 80
CMD ["yarn", "start"]