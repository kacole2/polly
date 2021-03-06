#!/bin/bash

BINTRAY_ACCOUNT=dvonthenen
BINTRAY_REPO=polly
BINTRAY_URL=https://api.bintray.com/content/$BINTRAY_ACCOUNT/$BINTRAY_REPO
BINTRAY_URL_STABLE=$BINTRAY_URL/stable/latest
BINTRAY_URL_STAGED=$BINTRAY_URL/staged/latest
BINTRAY_URL_STUPID=$BINTRAY_URL/unstable/latest

POLLY=polly
I386=i386
X86_64=x86_64
TGZ=tar.gz
LINUX=Linux
DARWIN=Darwin

LINUX_I386=$POLLY-$LINUX-$I386
LINUX_X86_64=$POLLY-$LINUX-$X86_64
DARWIN_X86_64=$POLLY-$DARWIN-$X86_64

STAGED_RX=-rc[[:digit:]]+$
STABLE_RX=^v?[[:digit:]]+\\.[[:digit:]]+\\.[[:digit:]]$

TGZS="$LINUX_I386.$TGZ $LINUX_X86_64.$TGZ $DARWIN_X86_64.$TGZ"
RPMS="polly-latest-$I386.rpm polly-latest-$X86_64.rpm"
DEBS="polly-latest-$X86_64.deb"
FILES="$TGZS $RPMS $DEBS"

bintray_delete_latest() {
    curl -vvf -u$BINTRAY_USER:$BINTRAY_KEY -X DELETE $1/$2 || true
    echo
}

for F in $FILES; do
    if [[ $TRAVIS_TAG =~ $STAGED_RX ]]; then
        bintray_delete_latest $BINTRAY_URL_STAGED $F
    elif [[ $TRAVIS_TAG =~ $STABLE_RX ]]; then
        bintray_delete_latest $BINTRAY_URL_STABLE $F
    else
        bintray_delete_latest $BINTRAY_URL_STUPID $F
    fi
done
