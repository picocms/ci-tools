##
# Evaluates a version string
#
# @author  Daniel Rudolf
# @link    http://picocms.org
# @license http://opensource.org/licenses/MIT
#

parse_version() {
    VERSION_FULL="${1#v}"

    if [[ "$VERSION_FULL" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(-([0-9A-Za-z\.\-]+))?(\+([0-9A-Za-z\.\-]+))?$ ]]; then
        VERSION_MAJOR="${BASH_REMATCH[1]}"
        VERSION_MINOR="${BASH_REMATCH[2]}"
        VERSION_PATCH="${BASH_REMATCH[3]}"
        VERSION_SUFFIX="${BASH_REMATCH[5]}"
        VERSION_BUILD="${BASH_REMATCH[7]}"

        VERSION_STABILITY="stable"
        if [[ "$VERSION_SUFFIX" =~ ^(dev|n|nightly|a|alpha|b|beta|rc)?([.-]?[0-9]+)?([.-](dev))?$ ]]; then
            if [ "${BASH_REMATCH[1]}" == "dev" ] || [ "${BASH_REMATCH[4]}" == "dev" ]; then
                VERSION_STABILITY="dev"
            elif [ "${BASH_REMATCH[1]}" == "n" ] || [ "${BASH_REMATCH[1]}" == "nightly" ]; then
                VERSION_STABILITY="nightly"
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

        return 0
    else
        return 1
    fi
}
