FROM wyveo/nginx-php-fpm:php82

COPY ./ /www/html
COPY ./docker/etc/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./sleep.sh /sleep.sh
RUN chmod 777 /www/html/application/config/config.php
RUN chmod 777 /www/html/application/config/database.php
RUN chmod 777 -R /www/html/updates
RUN chmod 777 /www/html/index.php
EXPOSE 80
RUN chmod +x /sleep.sh
CMD [ "/sleep.sh" ]