# Используем образ с уже установленным Playwright и Node.js
FROM mcr.microsoft.com/playwright:v1.49.1-noble

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы зависимостей
COPY package*.json ./

# Устанавливаем библиотеки (без всяких кэш-маунтов, которые бесят Railway)
RUN npm ci

# Копируем весь остальной код
COPY . .

# Собираем проект
RUN npm run build

# Указываем порт
ENV PORT=3000
EXPOSE 3000

# ГЛАВНОЕ: Жестко прописываем запуск на 0.0.0.0
# Чтобы Railway видел сервер, а не localhost
CMD ["node", "cli.js", "--host", "0.0.0.0", "--port", "3000", "--headless", "--browser", "chromium", "--no-sandbox"]
