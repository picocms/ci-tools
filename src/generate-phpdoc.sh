#!/bin/bash
# ci-tools -- generate-phpdoc.sh
# Generates phpDoc class documentation.
#
# This file is part of Pico, a stupidly simple, blazing fast, flat file CMS.
# Visit us at https://picocms.org/ for more info.
#
# Copyright (c) 2015  Daniel Rudolf <https://www.daniel-rudolf.de>
#
# This work is licensed under the terms of the MIT license.
# For a copy, see LICENSE file or <https://opensource.org/licenses/MIT>.
#
# SPDX-License-Identifier: MIT
# License-Filename: LICENSE

set -eu -o pipefail
export LC_ALL=C

# parameters
PHPDOC_CONFIG="$1"      # phpDoc config file
PHPDOC_TARGET_DIR="$2"  # phpDoc output dir
PHPDOC_CACHE_DIR="$3"   # phpDoc cache dir
PHPDOC_TITLE="$4"       # API docs title

# print parameters
echo "Generating phpDoc class documentation..."
printf 'PHPDOC_CONFIG="%s"\n' "$PHPDOC_CONFIG"
printf 'PHPDOC_TARGET_DIR="%s"\n' "$PHPDOC_TARGET_DIR"
printf 'PHPDOC_CACHE_DIR="%s"\n' "$PHPDOC_CACHE_DIR"
printf 'PHPDOC_TITLE="%s"\n' "$PHPDOC_TITLE"
echo

# update phpDoc class docs (i.e. rewrite API docs)
echo "Update phpDoc class docs..."
rm -rf "$PHPDOC_TARGET_DIR"
phpdoc run --config "$PHPDOC_CONFIG" \
    --target "$PHPDOC_TARGET_DIR" \
    --cache-folder "$PHPDOC_CACHE_DIR" \
    --title "$PHPDOC_TITLE"

# check for changes
if [ "$PHPDOC_CACHE_DIR" != "$PHPDOC_TARGET_DIR" ]; then
    echo
    echo "Check for phpDoc cache changes..."

    if [ -z "$(git status --porcelain "$PHPDOC_CACHE_DIR")" ]; then
        echo "No changes detected; skipping phpDoc class docs renewal..."
    fi
fi