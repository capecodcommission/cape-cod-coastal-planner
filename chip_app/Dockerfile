FROM node
WORKDIR /app
COPY . /app
RUN yarn upgrade
RUN yarn global add elm elm-test nodemon
RUN yarn
EXPOSE 3000
# CMD ["nodemon", "-L", "src", "scripts/start.js"]
CMD ["yarn", "start"]