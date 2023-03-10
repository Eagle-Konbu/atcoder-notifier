#!/bin/bash

set -eu

yum -y install zip

swift build --product Notifier -c release --arch arm64 -Xswiftc -static-stdlib

target=.build/lambda

rm -rf "$target"
mkdir -p "$target"

cp ".build/release/Notifier" "$target/"
cd "$target"
ln -s "Notifier" "bootstrap"
zip --symlinks lambda.zip *
