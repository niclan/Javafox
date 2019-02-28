#!/bin/bash

if [ -r ~/.java/deployment/security/exception.sites ]
then
    echo "Exception sites:"
    cat ~/.java/deployment/security/exception.sites
fi

cp /dev/null ~/.Xauthority
chmod 600 ~/.Xauthority
sudo cat "$XAUTHORITY" > ~/.Xauthority
unset XAUTHORITY

mkdir -p ~/.local/share

/usr/bin/firefox-esr -no-remote $@
