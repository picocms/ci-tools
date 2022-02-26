# ci-tools -- parse_version.inc.sh
# Declares the 'parse_version' shell function, which parses a version string
# and breaks it up into its version components. This file must be sourced.
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

function parse_version {
    VERSION_FULL="${VERSION#v}"

    if ! [[ "$VERSION_FULL" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(-([0-9A-Za-z\.\-]+))?(\+([0-9A-Za-z\.\-]+))?$ ]]; then
        return 1
    fi

    VERSION_MAJOR="${BASH_REMATCH[1]}"
    VERSION_MINOR="${BASH_REMATCH[2]}"
    VERSION_PATCH="${BASH_REMATCH[3]}"
    VERSION_SUFFIX="${BASH_REMATCH[5]}"
    VERSION_BUILD="${BASH_REMATCH[7]}"

    VERSION_STABILITY="stable"
    if [[ "$VERSION_SUFFIX" =~ ^(dev|a|alpha|b|beta|rc)?([.-]?[0-9]+)?([.-](dev))?$ ]]; then
        if [ "${BASH_REMATCH[1]}" == "dev" ] || [ "${BASH_REMATCH[4]}" == "dev" ]; then
            VERSION_STABILITY="dev"
        elif [ "${BASH_REMATCH[1]}" == "a" ] || [ "${BASH_REMATCH[1]}" == "alpha" ]; then
            VERSION_STABILITY="alpha"
        elif [ "${BASH_REMATCH[1]}" == "b" ] || [ "${BASH_REMATCH[1]}" == "beta" ]; then
            VERSION_STABILITY="beta"
        elif [ "${BASH_REMATCH[1]}" == "rc" ]; then
            VERSION_STABILITY="rc"
        fi
    fi

    VERSION_MILESTONE="$VERSION_MAJOR.$VERSION_MINOR"
    VERSION_NAME="$VERSION_MAJOR.$VERSION_MINOR.$VERSION_PATCH"
    VERSION_ID="$VERSION_MAJOR$(printf '%02d' "$VERSION_MINOR")$(printf '%02d' "$VERSION_PATCH")"
    VERSION_ID="$(printf '%01d' "$(echo "$VERSION_ID" | sed 's/^0*//')")"
}
