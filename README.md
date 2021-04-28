# Javafox

Java is going out of style and yet is needed to manage many different lights out management systems such as HPs iLO and such.  To be able to continue manage hardware some specific combinations of browsers and java is needed.

Thanks to a pull request you can now also run ancient Firefoxes for those that need browsers to support ancient BMCs with ancient now-unsupported https: encryption.

## No Oracle No More

As of 2019-04-16 Oracle has changed the license for Java to a **very restrictive** license which is at odds with using it at work at all.  Therefore the package has been updatet to use OpenJDK and the IcedTea Firefox plugin.  This combination still works well with HP iLO2 which is the oldest hardware I have access to.

If you need to use Oracle Java 8 please refer to commit dd7ccd6 (https://github.com/niclan/Javafox/tree/dd7ccd683f61444b027779e2bdddd7be1bd9eac8) and note that you can not use it with anything but personal computers and personally owned equipment in any way unless you have a previously downloaded JRE you can use with it.

Or if you have a paid up license with Oracle.

## Installing

1. Install docker (docker.io)

2. Clone this repository

3. (if on OSX): install XQuartz (xquartz.org)

4. (if on OSX): reboot (needed for some env variables)

5. Run ```docker build -t javafox .```  This makes a Ubuntu 16.04 docker image labeled "javafox" containing firefox-esr-52, java, flash and a account called ffuser.  The image is >1GB at time of creation. It will save caches and other config (java and firefox) outside the container in your home directory under ~/.javafox.

## Using

```./javafox``` starts the docker container. Type "about:" in the address bar to see that you have version 52.  Type "about:plugins" to see that Java and Flash is working.

To allow Java to run the unsecurely and out-of-date signed java apps you need to make security exceptions. To do this first start the docker image with ```./javafox``` you should then have a file in $HOME/.javafox/.java/deployment/security/exception.sites where you can add your exceptions like this:

```
https://192.168.254.0
https://192.168.254.1
```

## Remote media

I first needed to use this feature in 2021 so I'll just describe the workaround I used to access a media image file:

You can copy image files into your host directory: `~/.javafox/.mozilla`.  In the contained javafox you can browse into the `HOME/.mozilla` directory and find the image file there.

## Other legacy Firefox versions

There is an alternative `Dockerfile-legacy`.  This can be used to build historic images, although without Flash or Java.  Run

```
docker build -t firefox:2 -f Dockerfile-legacy .
ln -s javafox firefox-2
```

Running the symlink will launch this image instead.

Dependencies have not been tested for all releases, but
```
docker build --build-arg RELEASE=15.0.1 -t firefox:15 -f Dockerfile-legacy .
```
should work to make an image for Firefox 15.  See
<https://ftp.mozilla.org/pub/firefox/releases/> for the full archive.

## SElinux

When SElinux is enabled, a container will not be allowed to access the X11 socket.  See `selinux/javafox.te` for the access needed (tested on Fedora 29).

## Thanks

Thanks to Ole for making this usable! And to Kjetilho for supporting ancient Firefoxen.

Thanks to the Albuquerque Linux User Group for this article: https://www.abqlug.com/tutorials/how-to-install-firefox-esr-52-9-on-ubuntu-18-04/ and keeping a archive of the Firefox packages that I needed to resurect this thing in 2021.
