#!/usr/bin/env bash

BASEDIR=$(dirname $0)
cd $BASEDIR

BERKS_BIN=`which berks`
if [ $? -ne 0 ]; then
    echo "You must install Berkshelf!"
    echo "Checkout ChefDK with integrated Berkshelf: https://downloads.chef.io/chef-dk/"
else
    echo "Berkshelf installation detected: Using $BERKS_BIN"
fi

rm -r berks-cookbooks
berks vendor
