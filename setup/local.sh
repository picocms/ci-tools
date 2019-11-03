#!/usr/bin/env bash
set -e

echo "Checking build dependencies..."

while [ $# -gt 0 ]; do
    case "$1" in
        "--cloc")
            if [ ! -x "$(which cloc)" ]; then
                echo "Missing build dependency: cloc" >&2
                exit 1
            fi
            ;;

        "--phpdoc")
            if [ ! -x "$(which phpdoc)" ]; then
                echo "Missing build dependency: phpdoc" >&2
                exit 1
            fi
            ;;

        "--phpcs")
            if [ ! -x "$(which phpcs)" ]; then
                echo "Missing build dependency: phpcs" >&2
                exit 1
            fi
            ;;

        *)
            echo "Unknown build dependency: $1" >&2
            exit 1
    esac
    shift
done
echo
