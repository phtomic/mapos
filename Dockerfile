FROM wyveo/nginx-php-fpm:php82
RUN apt-get update && apt-get -y install cron

COPY ./install /www/html/install
COPY ./application/config/database.php /www/config/database.php
COPY ./robots.txt /www/html/robots.txt
COPY ./application/config/config.php /www/config/config.php
COPY ./index.php /www/config/index.php
COPY ./application /www/html/application
COPY ./assets /www/config/assets
COPY ./updates /www/html/updates
COPY ./banco.sql /www/html/banco.sql
COPY ./docker/etc/nginx/default.conf /etc/nginx/conf.d/default.conf
RUN rm /www/html/application/config/database.php
RUN rm /www/html/application/config/config.php
RUN ln -s /www/config/database.php /www/html/application/config/database.php
RUN ln -s /www/config/config.php /www/html/application/config/config.php
RUN ln -s /www/config/index.php /www/html/index.php
RUN ln -s /www/config/assets /www/html/assets
RUN chmod 777 -R /www/config
COPY ./bash /www/html/bash
RUN chmod +x -R /www/html/bash
EXPOSE 80
RUN chmod 777 -R /www/html/updates
CMD [ "/www/html/bash/sleep.sh" ]