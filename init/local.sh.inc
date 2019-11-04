function __picocms_cmd {
    echo "\$" "$@"
    "$@"
    return $?
}

# guess PICO_TOOLS_DIR path and add it to $PATH
__picocms_cmd export PICO_TOOLS_DIR="$(readlink -e "$(dirname "${BASH_SOURCE[0]}")/..")"
export PATH="$PICO_TOOLS_DIR:$PATH"

# set environment variables
__picocms_cmd export PICO_BUILD_ENV="local"

__picocms_cmd export PICO_PROJECT_DIR="$(readlink -e "$PWD")"
__picocms_cmd export PICO_BUILD_DIR="$PICO_PROJECT_DIR/.build/build"
__picocms_cmd export PICO_DEPLOY_DIR="$PICO_PROJECT_DIR/.build/deploy"

__picocms_cmd export PICO_DEPLOYMENT="$(git symbolic-ref --short HEAD)"

__picocms_cmd export PROJECT_REPO_SLUG="$(git remote get-url origin | gawk 'match($0, /(@|\/)?github\.com(:\/?|\/)([^\/]+\/[^\/]+)\.git$/, a) { print a[3]; }')"
__picocms_cmd export PROJECT_REPO_COMMIT="$(git rev-parse --verify HEAD)"

if [ -z "$PROJECT_REPO_TAG" ]; then
    __picocms_cmd export PROJECT_REPO_BRANCH="$(git symbolic-ref --short HEAD)"
    unset PROJECT_REPO_TAG
else
    __picocms_cmd export PROJECT_REPO_TAG="$PROJECT_REPO_TAG"
    unset PROJECT_REPO_BRANCH
fi

