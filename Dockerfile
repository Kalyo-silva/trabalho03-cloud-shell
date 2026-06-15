FROM ubuntu:24.04


RUN apt-get update \
 && apt-get install -y apache2 curl bc

WORKDIR /app

COPY . .

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
