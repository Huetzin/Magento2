#!/bin/bash

set -e

$(chown -R $MAGENTO_USER:$MAGENTO_USER $SERVER_DOCROOT)
$(chown -R $MAGENTO_USER:$MAGENTO_USER /home/$MAGENTO_USER/.ssh)
$(chmod -R 770 $SERVER_DOCROOT)

$(chown -R $MAGENTO_USER:$MAGENTO_USER /home/$MAGENTO_USER/.composer)
$(chmod 600 /home/$MAGENTO_USER/.composer/auth.json)

[ ! -z "${PUBLIC_KEY}" ] && sed -i "s/PUBLIC_KEY/${PUBLIC_KEY}/" /home/${MAGENTO_USER}/.composer/auth.json
[ ! -z "${PRIVATE_KEY}" ] && sed -i "s/PRIVATE_KEY/${PRIVATE_KEY}/" /home/${MAGENTO_USER}/.composer/auth.json

[ ! -z "${MAGENTO_USER}" ] && sed -i "s/MAGENTO_USER/${MAGENTO_USER}/" /etc/supervisord.conf

$(supervisord -n -c /etc/supervisord.conf)

exec "$@"