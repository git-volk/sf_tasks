# Используйте официальный образ Python в качестве базового
FROM python:3.9-slim

# Установите необходимые библиотеки
RUN pip install --no-cache-dir Flask psycopg2-binary ConfigParser

# Создайте рабочую директорию
WORKDIR /srv/app

# Скопируйте файлы приложения и конфигурации в контейнер
COPY ./web.py /srv/app/web.py
COPY ./web.conf /srv/app/conf/web.conf

# Убедитесь, что у скрипта есть права на выполнение
RUN chmod +x /srv/app/web.py

# Укажите команду по умолчанию для запуска приложения
CMD ["python", "web.py"]