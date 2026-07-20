ARG PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# ------------------------------
# Base
# ------------------------------
FROM node:22-bookworm-slim AS base

ARG PLAYWRIGHT_BROWSERS_PATH
ENV PLAYWRIGHT_BROWSERS_PATH=${PLAYWRIGHT_BROWSERS_PATH}

WORKDIR /app

# Исправление 1: Вместо сложных --mount просто копируем файлы
COPY package*.json ./

# Исправление 2: Установка без кеша, который блокирует Railway
RUN npm ci --omit=dev && \
    npx -y playwright-core install-deps chromium

# ------------------------------
# Builder
# ------------------------------
FROM base AS builder

# Копируем всё для сборки
COPY . .
RUN npm ci && npm run build

# ------------------------------
# Browser
# ------------------------------
FROM base AS browser
RUN npx -y playwright-core install --no-shell chromium

# ------------------------------
# Runtime
# ------------------------------
FROM base

ARG PLAYWRIGHT_BROWSERS_PATH
ARG USERNAME=node
ENV NODE_ENV=production

# Исправление 3: Копируем билд из билдера (добавили путь)
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=browser --chown=${USERNAME}:${USERNAME} ${PLAYWRIGHT_BROWSERS_PATH} ${PLAYWRIGHT_BROWSERS_PATH}
COPY --chown=${USERNAME}:${USERNAME} cli.js package.json ./

# Настройки прав
RUN chown -R ${USERNAME}:${USERNAME} /app
USER ${USERNAME}

WORKDIR /app

# ФИНАЛ: Добавляем host и port прямо в запуск, чтобы не зависеть от настроек Railway
ENTRYPOINT ["node", "cli.js", "--headless", "--browser", "chromium", "--no-sandbox", "--host", "0.0.0.0", "--port", "3000"]
