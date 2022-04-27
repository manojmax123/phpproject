FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install apt-utils -y
RUN apt-get install curl -y
RUN apt-get install g++ -y

ARG DEBIAN_FRONTEND=noninteractive

#RUN add-apt-repository ppa:ondrej/php

RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php 
RUN apt-get update -y

RUN apt-get install php7.4 -y
#RUN apt-get install php7.4-fpm -y
RUN apt-get install php7.4-cli -y
RUN apt-get install php7.4-intl -y
RUN apt-get install php7.4-cgi -y
RUN apt-get install php7.4-xsl -y
RUN apt-get install php7.4-soap -y
RUN apt-get install php7.4-json -y
RUN apt-get install php7.4-common -y
RUN apt-get install php7.4-mysql -y
RUN apt-get install php7.4-zip -y
RUN apt-get install php7.4-gd -y
RUN apt-get install php7.4-mbstring -y
RUN apt-get install php7.4-curl -y
RUN apt-get install php7.4-xml -y
RUN apt-get install php7.4-xmlrpc -y
RUN apt-get install php7.4-bcmath -y
RUN apt-get install php7.4-opcache -y
#RUN apt-get install php7.4-calender -y
#RUN apt-get install php7.4-pdo_mysql -y
#RUN apt-get install php7.4-bz2 -y

#RUN apt-get install php7.4-imagick -y
#RUN apt-get install php7.4-tidy -y

#RUN apt-get install -y build-essential
#RUN apt-get install -y libreadline-dev
#RUN apt-get install -y libbz2-dev
#RUN apt-get install -y libpng-dev
#RUN apt-get install -y libjpeg-dev
#RUN apt-get install -y libfreetype6-dev
#RUN apt-get install -y libicu-dev

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php -y
RUN php -r "unlink('composer-setup.php');"

RUN mv composer.phar /usr/local/bin/composer

RUN apt-get install apache2 -y
RUN apt-get install apache2-utils -y

RUN echo "ServerName 172.17.0.5" >> /etc/apache2/apache2.conf

#RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

WORKDIR /var/www/html/

RUN rm index.html
COPY . .

RUN composer install

WORKDIR /etc/apache2/sites-available/

RUN rm 000-default.conf 

COPY 000-default.conf .

#RUN service apache2 start
#RUN service apache2 reload
#RUN service apache2 restart

RUN a2enmod rewrite headers

EXPOSE 80

CMD ["apache2ctl","-D","FOREGROUND"]
#CMD ["php","-q","./index.php"]
