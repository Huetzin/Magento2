FROM php:7.1.13-apache-jessie

ENV PHP_MEMORY_LIMIT=4G
ENV PHP_DEFAULT_TIMEZONE=America/Mexico_City
ENV SERVER_DOCROOT=/var/www/html
ENV PUBLIC_KEY=0240f44287e3009842c4679d1e244313
ENV PRIVATE_KEY=a82dc5067b1d30f5fa5c51d079caa2ad
ENV MAGENTO_USER=magento
ENV MAGENTO_VERSION=LATEST

RUN buildDeps=" \
        libmysqlclient-dev \
        libsasl2-dev \
        build-essential \
    " \
    runtimeDeps=" \
        netcat \
        vim \
        curl \
        git \
        cron \
        sudo \
        openssh-server \
        mysql-client\
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libpng12-dev \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && docker-php-ext-install bcmath calendar intl mcrypt opcache pdo_mysql soap zip xsl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && pecl install -o -f xdebug \
    && docker-php-ext-enable xdebug \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /var/lib/apt/lists/* \
    && a2enmod rewrite \
    && echo "opcache.save_comments=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.memory_consumption=512" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.max_accelerated_files=100000" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.consistency_checks=0" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host=127.0.0.1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.show_local_vars=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.max_nesting_level=1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && mkdir /var/run/sshd \
    && echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config \
    && useradd -m -d /home/$MAGENTO_USER -s /bin/bash $MAGENTO_USER \
    && usermod -aG sudo $MAGENTO_USER \
    && touch /etc/sudoers.d/privacy \
    && echo "Defaults        lecture = never" >> /etc/sudoers.d/privacy \
    && chmod -R 770 $SERVER_DOCROOT \
    && chown -R $MAGENTO_USER:$MAGENTO_USER $SERVER_DOCROOT \
    && sed -i 's/www-data/$MAGENTO_USER/g' /etc/apache2/envvars \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -sL https://deb.nodesource.com/setup_9.x | bash -

RUN apt-get update && apt-get install -y nodejs

COPY /etc/php.ini /usr/local/etc/php/
COPY /etc/000-default.conf /etc/apache2/sites-available/
COPY /etc/auth.json /home/${MAGENTO_USER}/.composer/
COPY /scripts/context.sh /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

 ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

 EXPOSE 80
 CMD ["context.sh"]


