FROM nginx

ENV DEBIAN_FRONTEND noninteractive

#Setup PHP
RUN apt-get update --fix-missing &&  apt-get install -y php5-fpm php5-memcache php5 php5-mcrypt php5-cli php5-curl php5-gd php5-imagick php5-mcrypt php5-mysql php5-sqlite php5-xmlrpc php5-xsl php-pear php5-intl php-apc

RUN php5enmod mcrypt

#Setup Nginx Global Settings
COPY nginx.conf /etc/nginx/nginx.conf
COPY www.conf /etc/php5/fpm/pool.d/www.conf
COPY php.ini  /etc/php5/fpm/php.ini

RUN chown www-data /etc/php5/fpm/pool.d/www.conf

RUN mkdir -p /workspace

VOLUME /workspace

CMD service php5-fpm start && nginx
