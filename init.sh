#!/bin/sh
set -e # exit on error

mkdir ~/.r1_init/bin -p
work_dir="$HOME/.r1_init"
bin_dir="$work_dir/bin"

if [ ! "$(command -v node)" ]; then
    echo -n "Node binary not found.\nDownloading (portable version)... " >&2
    if [ "$(command -v curl)" ]; then
        sh -c "$(curl -so $work_dir/node.tar.xz \
        https://nodejs.org/dist/v16.15.0/node-v16.15.0-linux-x64.tar.xz)" -- b \
        "$bin_dir"
    elif [ "$(command -v wget)" ]; then
        sh -c "$(wget -qO $work_dir/node.tar.xz \
        https://nodejs.org/dist/v16.15.0/node-v16.15.0-linux-x64.tar.xz)" -- b \
        "$bin_dir"
    else
        echo "\nTo run the script, you must have curl or wget installed." >&2
        exit 1
    fi

    echo -n "ok.\nExtracting... " >&2
    # tar -Jxvf "$work_dir/node.tar.xz" \
    # "node-v16.15.0-linux-x64/bin/node -C $bin_dir --strip-components=2"
    cd $bin_dir
    tar -Jxf "$work_dir/node.tar.xz" "node-v16.15.0-linux-x64/bin/node" --strip-components=2
    rm $work_dir/node.tar.xz
    chmod +x $bin_dir/node
    echo "ok."
else
    echo "Node binary found." >&2
fi

echo -n "Getting script... " >&2
if [ "$(command -v curl)" ]; then
    sh -c "$(curl -so $work_dir/index.js \
    https://github.com/AirOne01/init/raw/main/index.js)" -- b \
    "$work_dir"
elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO $work_dir/index.js \
    https://github.com/AirOne01/init/raw/main/index.js)" -- b \
    "$work_dir"
else
    echo "To run the script, you must have curl or wget installed." >&2
    exit 1
fi

echo "ok.\n\nLaunching script..." >&2
$bin_dir/node $work_dir/index.js

rm -rf "$work_dir"
