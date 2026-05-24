# Домашняя работа №4 — Dockerfile

## Задание

Написать Dockerfile для образа с Nginx и PostgreSQL.
Использовать инструкции: FROM, MAINTAINER, RUN, CMD, WORKDIR, ENV, ADD, COPY, VOLUME, USER, EXPOSE.

## Сборка

```bash
docker build -t nikiforov_ra_image_$(date +%Y%m%d) .
```

## Запуск

```bash
docker run -d -p 80:80 -p 5432:5432 nikiforov_ra_image_20260524
```

## Слои образа

```bash
 docker history nikiforov_ra_image_20260524
```

## Проверяем, что контейнер запустился

```bash
 docker ps
```

## Проверяем nginx

```bash
 curl http://localhost
```

## Смотрим список БД

```bash
 docker exec -it unruffled_aryabhata su - postgres -c "psql -c '\l'"
```

![image](image.png)
