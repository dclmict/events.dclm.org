FROM opeoniye/php74-base:latest

# set working directory
WORKDIR /var/www

# add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# copy code
COPY --chown=www-data:www-data ./src /var/www

# set permissions for laravel app
RUN chmod -R ug+w /var/www/storage

# copy configs/scripts
COPY ./ops/docker/run.sh /var/docker/run.sh
COPY ./ops/docker/supervisor.conf /etc/supervisord.conf
COPY ./ops/docker/php/php.ini /usr/local/etc/php/conf.d/app.ini
COPY ./ops/docker/ngx/nginx.conf /etc/nginx/nginx.conf
COPY ./ops/docker/ngx/events.conf /etc/nginx/sites-enabled/default
COPY ./ops/docker/ngx/ssl.conf /etc/nginx/ssl.conf
COPY ./ops/docker/ngx/proxy /etc/nginx/proxy_params
COPY ./ops/docker/ngx/exploit.conf /etc/nginx/snippets/exploit_protection.conf
COPY ./ops/docker/ngx/optimize.conf /etc/nginx/snippets/site_optimization.conf
COPY ./ops/docker/ngx/log.conf /etc/nginx/snippets/logging.conf

# php log files
RUN mkdir /var/log/php; \
  touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

## deployment
RUN chmod +x /var/docker/run.sh

EXPOSE 89
ENTRYPOINT ["/var/docker/run.sh"]