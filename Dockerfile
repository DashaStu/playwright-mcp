# Используем образ с готовым Playwright
FROM mcr.microsoft.com/playwright:v1.49.1-noble

WORKDIR /app

# Копируем настройки
COPY package.json package-lock.json ./
RUN npm ci

# Устанавливаем браузер заранее
RUN npx playwright install chromium

# Копируем код
COPY . .

# Собираем проект
RUN npm run build

# Указываем порт
ENV PORT=3000
EXPOSE 3000

# ГЛАВНОЕ: Мы убираем ENTRYPOINT и используем только CMD
# Мы жестко прописываем 0.0.0.0, чтобы он точно открылся миру
CMD ["node", "cli.js", "--host", "0.0.0.0", "--port", "3000", "--headless", "--browser", "chromium", "--no-sandbox"]
