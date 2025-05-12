#!/usr/bin/env bash

BUILD_ROOT="$PWD"
LE_ROOT="${BUILD_ROOT}/LE"

function sync_repo {
    mkdir -p "$1" && cd "$1"
    echo "[+] Changed directory to $1."

    if repo init --depth=1 --no-clone-bundle -u https://github.com/LittlenineEnnea/SM8650_BSP_Sync -b main -m "$2"; then
        echo "[+] Repo initialized successfully."
    else
        echo "[-] Error: Failed to initialize repo."
        exit 1
    fi

    echo "[+] Starting repo sync..."
    if schedtool -B -e ionice -n 0 repo sync -c --force-sync --optimized-fetch --no-tags --retry-fetches=5 -j"$(nproc --all)"; then
        echo "[+] Repo synced successfully."
    else
        echo "[-] Error: Failed to sync repo."
        exit 1
    fi
}

sync_repo "$LE_ROOT" "le.xml"

cd "$BUILD_ROOT"
echo "[+] Successfully returned to the build root."
