FROM mysql:8.1

COPY ./sql/dump.sql /docker-entrypoint-initdb.d

EXPOSE 3306