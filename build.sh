#!/bin/bash

swift build --product Notifier -c release -Xswiftc -static-stdlib

target=.build/lambda

rm -rf "$target"
mkdir -p "$target"

cp ".build/release/Notifier" "$target/"
cd "$target"
ln -s "Notifier" "bootstrap"
zip --symlinks lambda.zip *