FROM node
WORKDIR /app
COPY . /app
RUN yarn upgrade
RUN yarn global add elm elm-test
RUN yarn
RUN yarn run api
EXPOSE 3000
CMD ["yarn", "start"] 
