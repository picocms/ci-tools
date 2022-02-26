#!/bin/bash
# ci-tools -- generate-badge.sh
# Downloads a custom badge from shields.io.
#
# All credit goes to the awesome folks at shields.io!
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
BADGE_FILE_PATH="$1"  # target file path
BADGE_SUBJECT="$2"    # subject (left half) of the badge
BADGE_STATUS="$3"     # status (right half) of the badge
BADGE_COLOR="$4"      # color of the badge

# print parameters
echo "Generating badge..."
printf 'BADGE_FILE_PATH="%s"\n' "$BADGE_FILE_PATH"
printf 'BADGE_SUBJECT="%s"\n' "$BADGE_SUBJECT"
printf 'BADGE_STATUS="%s"\n' "$BADGE_STATUS"
printf 'BADGE_COLOR="%s"\n' "$BADGE_COLOR"
echo

# download badge from shields.io
echo "Downloading badge..."
TMP_BADGE="$(mktemp -u)"

curl -fsS -L -o "$TMP_BADGE" \
    "https://img.shields.io/badge/$BADGE_SUBJECT-$BADGE_STATUS-$BADGE_COLOR.svg"

# validate badge
if [ ! -f "$TMP_BADGE" ] || [ ! -s "$TMP_BADGE" ]; then
    echo "Unable to generate badge"
    exit 1
fi

TMP_BADGE_MIME="$(file --mime-type "$TMP_BADGE" | cut -d ' ' -f 2)"
if [ "$TMP_BADGE_MIME" != "image/svg" ] && [ "$TMP_BADGE_MIME" != "image/svg+xml" ]; then
    echo "Generated badge should be of type 'image/svg+xml', '$TMP_BADGE_MIME' given"
    exit 1
fi

# deploy badge
echo "Replacing badge file..."
mv "$TMP_BADGE" "$BADGE_FILE_PATH"
