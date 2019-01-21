# Javafox

Java is going out of style and yet is needed to manage many different lights out management systems such as HPs iLO and such.  To be able to continue manage hardware some specific combinations of browsers and java is needed.

## Installing

1. Install docker (docker.io)

2. Clone this repository

3. Run ```docker build -t javafox .```  This makes a Ubuntu 16.04 docker image labeled "javafox" containing firefox-esr-52, java, flash and a account called ffuser.  The image is >1GB at time of creation. It will save caches and other config (java and firefox) outside the container in your home directory under ~/.javafox.

## Using

```./javafox``` starts the docker container. Type "about:" in the address bar to see that you have version 52.  Type "about:plugins" to see that Java and Flash is working.

To allow Java to run the unsecurely and out-of-date signed java apps you need to make security exceptions.
To do this first start the docker image with ```./javafox``` you should then have a file in $HOME/.javafox/.java/deployment/security/exception.sites where you can add your exceptions like this:

```
https://192.168.254.0
https://192.168.254.1
```

## Thanks

Thanks to Ole for making this usable!
