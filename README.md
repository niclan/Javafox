# Javafox

Java is going out of style and yet is needed to manage many different lights out management systems such as HPs iLO and such.  To be able to continue manage hardware some specific combinations of browsers and java is needed.

## Installing

1. Install docker (docker.io)
1. Clone this repository
1. Get Firefox ESR 52 from here: https://www.mozilla.org/en-US/firefox/organizations/all/ - this version of Firefox still supports the java plugin
1. In the checked out repository unpack your java tarball so that it is unpacked in a "firefox" directory.
1. To allow Java to run the unsecurely and out-of-date signed java apps you need to make security exceptions.   Make a file called "exception.sites" in this kind of format:

```
https://192.168.254.0
https://192.168.254.1
```

6. Run ```sudo docker build -t firefox .```  This makes a Ubuntu 16.04 docker image labeled "firefox" containing firefox, java, flash (broken right now), and a account called ffuser.  The image is >1GB at time of creation and will grow some as firefox and java accumulates cached files from the sites you surf.

## Using

We have problems but it will work.

```./runff``` starts the docker container, it gives you a bash prompt.  Type "firefox".  It might crash.  Start it again, it should come up.  Type "about:" in the address bar to see that you have version 52.  Type "about:plugins" to see that Java is working.

## Bugs:

Lots!  I have no idea why:
* Having firefox run as the default command always crashes
* Why it crashes the first time you run it from the bash prompt
* Why flash is not active (also needed for some management apps)
