#!/bin/sh
echo -ne '\033c\033]0;global game jam 2025\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/tubtussle_v4.x86_64" "$@"
