* * * * * /usr/local/bin/php /var/www/html/bin/magento cron:run | grep -v "Ran jobs by schedule" >> /var/www/html/var/log/magento.cron.log
* * * * * /usr/local/bin/php /var/www/html/bin/magento indexer:reindex
