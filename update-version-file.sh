#!/bin/bash
# ci-tools -- update-version-file.sh
# Updates the version file.
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

. "$(dirname "${BASH_SOURCE[0]}")/parse_version.inc.sh"

# parameters
VERSION_FILE_PATH="$1"  # target file path
VERSION_STRING="$2"     # version string (e.g. v1.0.0-beta.1+7b4ad7f)

# print parameters
echo "Generating version file..."
printf 'VERSION_FILE_PATH="%s"\n' "$VERSION_FILE_PATH"
printf 'VERSION_STRING="%s"\n' "$VERSION_STRING"
echo

# evaluate version string (see https://semver.org/)
echo "Parsing version string..."
if ! parse_version "$VERSION_STRING"; then
    echo "Invalid version string"
    exit 1
fi

# generate version file
echo "Updating version file..."
echo -n "" > "$VERSION_FILE_PATH"
exec 3> "$VERSION_FILE_PATH"

printf 'full: %s\n' "$VERSION_FULL" >&3
printf 'name: %s\n' "$VERSION_NAME" >&3
printf 'milestone: %s\n' "$VERSION_MILESTONE" >&3
printf 'stability: %s\n' "$VERSION_STABILITY" >&3
printf 'id: %d\n' "$VERSION_ID" >&3
printf 'major: %d\n' "$VERSION_MAJOR" >&3
printf 'minor: %d\n' "$VERSION_MINOR" >&3
printf 'patch: %d\n' "$VERSION_PATCH" >&3
printf 'suffix: %s\n' "$VERSION_SUFFIX" >&3
printf 'build: %s\n' "$VERSION_BUILD" >&3

exec 3>&-
