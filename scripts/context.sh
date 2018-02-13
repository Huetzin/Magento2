#!/bin/bash

set -e

cmd="$@"

getInstanceInfo(){
    su $MAGENTO_USER -c "php ${SERVER_DOCROOT}/bin/magento --version"

    if [ $? != 0 ]
        then
        return $TRUE
    else
        return $FALSE
    fi
}

createInstance(){
    echo "Creating Instance for Mqgento 2 ..."

    if [ $MAGENTO_VERSION == 'LATEST' ]
        then
            su $MAGENTO_USER -c "composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition ${SERVER_DOCROOT}"
    else
            su $MAGENTO_USER -c "composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=${MAGENTO_VERSION} ${SERVER_DOCROOT}"
    fi

    if [su $MAGENTO_USER -c "php ${SERVER_DOCROOT}/bin/magento --version 2>/dev/null"]
       then
           echo "Magento 2 Instance was created!"
    fi
}

startWebServer(){
    apache2-foreground
}

export -f getInstanceInfo
export -f createInstance
export -f startWebServer

if [ !getInstanceInfo ]
    then
        
        createInstance
        # until php ${SERVER_DOCROOT}/bin/magento --version 2>/dev/null
        # do
        #   echo -n .
        #   sleep 1
        # done
        startWebServer
        exec $cmd
else
    echo "Starting Web Server..." && startWebServer && echo "Web Server Ready!"
fi