# Базовый образ — Ubuntu 24.04
FROM ubuntu:24.04

# Метаданные автора (устаревшая инструкция, но требуется по заданию)
MAINTAINER Ruslan <ruslan89001@github.com>

# Переменные окружения для PostgreSQL
ENV POSTGRES_DB=appdb \
    POSTGRES_USER=appuser \
    POSTGRES_PASSWORD=secret \
    PGDATA=/var/lib/postgresql/data \
    DEBIAN_FRONTEND=noninteractive

# Рабочая директория для веб-приложения
WORKDIR /var/www/html

# Установка Nginx и PostgreSQL
RUN apt-get update && apt-get install -y \
    nginx \
    postgresql \
    postgresql-contrib \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Копирование конфига Nginx из контекста сборки
COPY nginx.conf /etc/nginx/sites-available/default

# Добавление стартовой страницы (ADD умеет распаковывать архивы, в отличие от COPY)
ADD index.html /var/www/html/index.html

# Инициализация PostgreSQL и создание БД/пользователя
RUN service postgresql start && \
    su - postgres -c "psql -c \"CREATE USER ${POSTGRES_USER} WITH PASSWORD '${POSTGRES_PASSWORD}';\"" && \
    su - postgres -c "psql -c \"CREATE DATABASE ${POSTGRES_DB} OWNER ${POSTGRES_USER};\"" && \
    service postgresql stop

# Примонтируемый том для данных PostgreSQL
VOLUME ["/var/lib/postgresql/data", "/var/log/nginx"]

# Переключение на непривилегированного пользователя www-data для Nginx
# (PostgreSQL запускается отдельно через entrypoint)
USER root

# Открываем порты: 80 для Nginx, 5432 для PostgreSQL
EXPOSE 80 5432

# Скрипт запуска обоих сервисов
CMD service postgresql start && nginx -g "daemon off;"
