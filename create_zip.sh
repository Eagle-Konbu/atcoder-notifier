#!/bin/bash

target=.build/lambda/Notifier

rm -rf "$target"
mkdir -p "$target"

cp ".build/release/Notifier" "$target/"
cp -Pv /usr/lib/swift/linux/lib*so* "$target/"
ln -s "Notifier" "bootstrap"
zip --symlinks lambda.zip *