#!/bin/bash

KIRK=$(jruby -S bundle show kirk)
ASPEN=$(jruby -S bundle show aspen)
eval $(jruby -S bundle exec env | egrep '^(BUNDLE_|RUBYOPT)' | sed 's/=\(.*\)/="\1"/')
export BUNDLE_BIN_PATH BUNDLE_GEMFILE RUBYOPT

if [ ! -f $KIRK/lib/kirk/native.jar ]; then
    echo "Building Kirk for the first time"
    pushd $KIRK
    jruby -S rake jar
    popd
fi

if [ ! -f $ASPEN/javalib/target/aspenj-1.0-SNAPSHOT.jar ]; then
    echo "Building Aspen for the first time"
    pushd $ASPEN/javalib
    mvn package
    popd
fi

echo "Starting $1..."
case $1 in
    aspen)
	jruby --server $RUBYOPT -S aspen start -R config.ru
	;;
    kirk)
	jruby --server $RUBYOPT -S kirk start
	;;
    mizuno)
	jruby --server $RUBYOPT -S mizuno -p 3000 > /dev/null 2>&1
	;;
    trinidad)
	jruby --server $RUBYOPT -S trinidad -r
	;;
    *)
	echo "unknown server: $1"
	echo "servers are: aspen kirk mizuno trinidad"
	;;
esac
