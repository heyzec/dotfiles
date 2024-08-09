FROM node:18

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY entrypoint.sh ./

RUN chmod +x ./entrypoint.sh

CMD ["./entrypoint.sh"]

