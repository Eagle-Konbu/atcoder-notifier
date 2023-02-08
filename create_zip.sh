#!/bin/bash

target=.build/lambda/Notifier

rm -rf "$target"
mkdir -p "$target"

cp ".build/release/Notifier" "$target/"
cd "$target"
ln -s "Notifier" "bootstrap"
zip --symlinks lambda.zip *