FROM mcr.microsoft.com/playwright:v1.49.1-noble

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build

ENV PORT=3000
EXPOSE 3000

CMD ["npx", "-y", "@playwright/mcp@latest", "--port", "3000", "--host", "0.0.0.0", "--headless"]
