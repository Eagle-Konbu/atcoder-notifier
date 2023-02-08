#!/bin/bash

swift build --product Notifier -c release -Xswiftc -g

target=.build/lambda

rm -rf "$target"
mkdir -p "$target"

cp ".build/release/Notifier" "$target/"
cp -Pv /usr/lib/swift/linux/lib*so* "$target"
cd "$target"
ln -s "Notifier" "bootstrap"
zip --symlinks lambda.zip *