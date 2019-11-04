#!/usr/bin/env bash

##
# Creates pre-built release archives (.tar.gz and .zip archives)
#
# @author  Daniel Rudolf
# @link    http://picocms.org
# @license http://opensource.org/licenses/MIT
#

set -e

# parameters
BUILD_DIR="$1"          # build directory to create a release of
ARCHIVE_DIR="$2"        # directory to create release archives in
ARCHIVE_FILENAME="$3"   # release archive file name (without file extension)

# print parameters
echo "Creating release archives..."
printf 'BUILD_DIR="%s"\n' "$BUILD_DIR"
printf 'ARCHIVE_DIR="%s"\n' "$ARCHIVE_DIR"
printf 'ARCHIVE_FILENAME="%s"\n' "$ARCHIVE_FILENAME"
echo

if [ -z "$ARCHIVE_DIR" ] || [ "$(readlink -e "$ARCHIVE_DIR")" == "$(readlink -e "$BUILD_DIR")" ]; then
    echo "Unable to create release archives: Invalid release archive target dir '$ARCHIVE_DIR'" >&2
    exit 1
fi
if [ -z "$ARCHIVE_FILENAME" ]; then
    echo "Unable to create release archives: No release archive file name given" >&2
    exit 1
fi

# prepare release
cd "$BUILD_DIR"

echo "Removing '.git' directory..."
rm -rf .git

echo "Removing '.git' directories of dependencies..."
find vendor/ -type d -path 'vendor/*/*/.git' -print0 | xargs -0 rm -rf

echo

# create release archives
echo "Creating release archive '$ARCHIVE_FILENAME.tar.gz'..."

if [ -e "$ARCHIVE_DIR/$ARCHIVE_FILENAME.tar.gz" ]; then
    echo "Unable to create release archive: File '$ARCHIVE_FILENAME.tar.gz' exists" >&2
    exit 1
fi

find . -mindepth 1 -maxdepth 1 -printf '%f\0' \
    | xargs -0 -- tar -czf "$ARCHIVE_DIR/$ARCHIVE_FILENAME.tar.gz" --
echo

echo "Creating release archive '$ARCHIVE_FILENAME.zip'..."

if [ -e "$ARCHIVE_DIR/$ARCHIVE_FILENAME.zip" ]; then
    echo "Unable to create release archive: File '$ARCHIVE_FILENAME.zip' exists" >&2
    exit 1
fi

zip -q -r "$ARCHIVE_DIR/$ARCHIVE_FILENAME.zip" .
