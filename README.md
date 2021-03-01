Flower 
------

[![](https://images.microbadger.com/badges/version/saxix/flower.svg)](https://hub.docker.com/r/saxix/flower/)


Flower Docker image with `URL_PREFIX` and OAuth Azure support


### Configuration

    
    - FLOWER_OAUTH2_REDIRECT_URI	[SERVER]/[FLOWER_URL_PREFIX]/login
    - FLOWER_OAUTH2_KEY 
    - FLOWER_OAUTH2_SECRET 


#### Optionals
    
    - FLOWER_ADDRESS 127.0.0.1
    - FLOWER_AUTH ".*"
    - FLOWER_AUTH_PROVIDER	flower_oauth_azure.tenant.AzureTenantLoginHandler
    - FLOWER_DEBUG	0
    - FLOWER_OAUTH2_VALIDATE	1
    - FLOWER_PORT 5555
    - FLOWER_URL_PREFIX "" # to be used when Flower does not have dedicated host

When `FLOWER_URL_PREFIX` is set you can also configure the proxy port address with

    - SERVER_NAME
    - SERVER_PORT
    - FLOWER_ADDRESS "127.0.0.1
