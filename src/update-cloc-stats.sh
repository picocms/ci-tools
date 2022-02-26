#!/bin/bash
# ci-tools -- update-cloc-stats.sh
# Updates the cloc statistics file.
#
# This file is part of Pico, a stupidly simple, blazing fast, flat file CMS.
# Visit us at https://picocms.org/ for more info.
#
# Copyright (c) 2017  Daniel Rudolf <https://www.daniel-rudolf.de>
#
# This work is licensed under the terms of the MIT license.
# For a copy, see LICENSE file or <https://opensource.org/licenses/MIT>.
#
# SPDX-License-Identifier: MIT
# License-Filename: LICENSE

set -eu -o pipefail
export LC_ALL=C

# parameters
TARGET_FILE="$1"           # statistics target file path
SOURCE_PATHS=( "${@:2}" )  # source paths

# print parameters
echo "Updating cloc statistics..."
printf 'TARGET_FILE="%s"\n' "$TARGET_FILE"
printf 'SOURCE_PATHS=( %s )\n' "${SOURCE_PATHS[@]@Q}"
echo

# define functions
function create_cloc_stats {
    local CLOC_FILE="$1"
    shift

    cloc --yaml --report-file "$CLOC_FILE" \
        --progress-rate 0 \
        --read-lang-def <(
            echo "JSON"
            echo "    filter remove_matches ^\s*$"
            echo "    extension json"
            echo "    3rd_gen_scale 2.50"
            echo "Twig"
            echo "    filter remove_between_general {# #}"
            echo "    extension twig"
            echo "    3rd_gen_scale 2.00"
            echo "Markdown"
            echo "    filter remove_html_comments"
            echo "    extension md"
            echo "    3rd_gen_scale 1.00"
            echo "Apache config"
            echo "    filter remove_matches ^\s*#"
            echo "    filter remove_inline #.*$"
            echo "    extension htaccess"
            echo "    3rd_gen_scale 1.90"
        ) \
        --force-lang PHP,php.dist \
        --force-lang YAML,yml.template \
        "$@"
}

function clean_cloc_stats {
    local LINE=""
    local IS_HEADER="no"
    while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
        if [ "$IS_HEADER" == "yes" ]; then
            # skip lines until next entry is reached
            [ "${LINE:0:2}" != "  " ] || continue
            IS_HEADER="no"
        elif [ "$LINE" == "header :" ]; then
            # header detected
            IS_HEADER="yes"
            continue
        fi

        echo "$LINE"
    done < <(tail -n +3 "$1")
}

# create temporary file
echo "Creating temporary file..."
TMP_FILE="$(mktemp)"
[ -n "$TMP_FILE" ] || exit 1
echo

# create statistics
echo "Creating statistics..."
create_cloc_stats "$TMP_FILE" "${SOURCE_PATHS[@]}"
echo

# remove headers from cloc statistics
echo "Writing statistics file without header..."
clean_cloc_stats "$TMP_FILE" > "$TARGET_FILE"
echo

# remove temporary file
echo "Removing temporary file..."
rm "$TMP_FILE"
