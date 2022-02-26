#!/bin/bash
# ci-tools -- update-phpdoc-list.sh
# Updates the list of phpDoc class documentations.
#
# This file is part of Pico, a stupidly simple, blazing fast, flat file CMS.
# Visit us at https://picocms.org/ for more info.
#
# Copyright (c) 2016  Daniel Rudolf <https://www.daniel-rudolf.de>
#
# This work is licensed under the terms of the MIT license.
# For a copy, see LICENSE file or <https://opensource.org/licenses/MIT>.
#
# SPDX-License-Identifier: MIT
# License-Filename: LICENSE

set -eu -o pipefail
export LC_ALL=C

# parameters
LIST_FILE_PATH="$1"    # target file path
LIST_ID="$2"           # phpDoc ID
LIST_TYPE="$3"         # phpDoc type
LIST_TITLE="$4"        # phpDoc title
LIST_LAST_UPDATE="$5"  # phpDoc last update

# print parameters
echo "Updating phpDoc list..."
printf 'LIST_FILE_PATH="%s"\n' "$LIST_FILE_PATH"
printf 'LIST_ID="%s"\n' "$LIST_ID"
printf 'LIST_TYPE="%s"\n' "$LIST_TYPE"
printf 'LIST_TITLE="%s"\n' "$LIST_TITLE"
printf 'LIST_LAST_UPDATE="%s"\n' "$LIST_LAST_UPDATE"
echo

# create temporary file
echo "Creating temporary file..."
LIST_TMP_FILE="$(mktemp)"
[ -n "$LIST_TMP_FILE" ] || exit 1

exec 3> "$LIST_TMP_FILE"

# walk through phpDoc list
echo "Walking through phpDoc list..."

DO_REPLACE="no"
DID_REPLACE="no"
while IFS='' read -r LINE || [[ -n "$LINE" ]]; do
    if [ "$DO_REPLACE" == "yes" ]; then
        # skip lines until next entry is reached
        [ "${LINE:0:2}" != "  " ] || continue
        DO_REPLACE="no"

    elif [ "$LINE" == "- id: $LIST_ID" ]; then
        # update existing entry
        echo "Updating existing entry..."
        printf -- '- id: %s\n' "$LIST_ID" >&3
        printf -- '  type: %s\n' "$LIST_TYPE" >&3
        printf -- '  title: %s\n' "$LIST_TITLE" >&3
        printf -- '  last_update: %s\n' "$LIST_LAST_UPDATE" >&3

        DO_REPLACE="yes"
        DID_REPLACE="yes"
        continue
    fi

    echo "$LINE" >&3
done < "$LIST_FILE_PATH"

# add new entry
if [ "$DID_REPLACE" == "no" ]; then
    echo "Adding new entry..."
    printf -- '- id: %s\n' "$LIST_ID" >&3
    printf -- '  type: %s\n' "$LIST_TYPE" >&3
    printf -- '  title: %s\n' "$LIST_TITLE" >&3
    printf -- '  last_update: %s\n' "$LIST_LAST_UPDATE" >&3
fi

exec 3>&-

# move temporary file
echo "Replacing phpDoc list..."
mv "$LIST_TMP_FILE" "$LIST_FILE_PATH"
