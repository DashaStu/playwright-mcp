FROM mcr.microsoft.com/playwright:v1.49.1-noble

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build

ENV PORT=3000
EXPOSE 3000

CMD ["node", "cli.js", "--headless", "--browser", "chromium", "--no-sandbox", "--transport", "http", "--host", "0.0.0.0", "--port", "3000"]
