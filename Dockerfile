FROM mcr.microsoft.com/playwright:v1.49.1-noble

WORKDIR /app

COPY package*.json ./
RUN npm ci
RUN npx playwright install chromium

COPY . .
RUN npm run build

# ЖЕСТКО ЗАДАЕМ ПЕРЕМЕННЫЕ (это сильнее командной строки)
ENV PLAYWRIGHT_MCP_HOST=0.0.0.0
ENV PLAYWRIGHT_MCP_PORT=3000
ENV PORT=3000

EXPOSE 3000

# Запускаем через переменную PORT
CMD ["node", "cli.js", "--host", "0.0.0.0", "--port", "3000", "--headless", "--browser", "chromium", "--no-sandbox"]
