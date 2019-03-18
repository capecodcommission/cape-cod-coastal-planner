FROM node
WORKDIR /app
COPY . /app
RUN yarn upgrade && yarn global add elm elm-test && yarn
EXPOSE 80
CMD ["yarn", "start"]