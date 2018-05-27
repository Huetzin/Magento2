#!/bin/bash

(crontab -l; echo '* * * * * /usr/local/bin/php /var/www/html/bin/magento cron:run | grep -v "Ran jobs by schedule" >> /var/www/html/var/log/magento.cron.log') | crontab -
(crontab -l; echo '* * * * * /usr/local/bin/php /var/www/html/update/cron.php >> /var/wwww/html/var/log/update.cron.log') | crontab -
(crontab -l; echo '* * * * * /usr/local/bin/php /var/www/html/bin/magento setup:cron:run >> /var/www/html/var/log/setup.cron.log') | crontab -




