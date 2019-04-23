# Javafox

Java is going out of style and yet is needed to manage many different lights out management systems such as HPs iLO and such.  To be able to continue manage hardware some specific combinations of browsers and java is needed.

Thanks to a pull request you can now also run ancient Firefoxes for those that need browsers to support ancient BMCs with ancient now-unsupported https: encryption.

# Oracle license

As of 2019-04-16 Oracle has changed the license for Java to a **very restrictive** license making these uses legal:

```
(i)     Personal Use,
(ii)    Development Use,
(iii)   Oracle Approved Product Use, and/or
(iv)   Oracle Cloud Infrastructure Use.
```

The definition of "personal use" is such that you can't use "Javafox" with Oracle JDK for work purposes in any way without breaking their license.  Therefore you can at this point only use build newly built "Javafox" docker files with personal computers for personal purposes, for personally owned lights out systems unless you have a license from Oracle.  Thread carefuly.

This package needs to be using OpenJDK. See https://github.com/niclan/Javafox/issues/8).

## Installing

1. Install docker (docker.io)

2. Clone this repository

3. Download java (JRE 8 for Linux/AMD64 the tar.gz version) from https://www.oracle.com/technetwork/java/javase/jre8-downloads-2133155.html.

4. Rename the jre to `jre-linux-x64.tar.gz`

4. Run ```docker build -t javafox .```  This makes a Ubuntu 16.04 docker image labeled "javafox" containing firefox-esr-52, java, flash and a account called ffuser.  The image is >1GB at time of creation. It will save caches and other config (java and firefox) outside the container in your home directory under ~/.javafox.

## Using

```./javafox``` starts the docker container. Type "about:" in the address bar to see that you have version 52.  Type "about:plugins" to see that Java and Flash is working.

To allow Java to run the unsecurely and out-of-date signed java apps you need to make security exceptions.
To do this first start the docker image with ```./javafox``` you should then have a file in $HOME/.javafox/.java/deployment/security/exception.sites where you can add your exceptions like this:

```
https://192.168.254.0
https://192.168.254.1
```

## Other legacy Firefox versions

There is an alternative `Dockerfile-legacy`.  This can be used to
build historic images, although without Flash or Java.  Run

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

When SElinux is enabled, a container will not be allowed to access the
X11 socket.  See `selinux/javafox.te` for the access needed (tested on
Fedora 29).

## Thanks

Thanks to Ole for making this usable! And to Kjetilho for supporting ancient Firefoxen.
