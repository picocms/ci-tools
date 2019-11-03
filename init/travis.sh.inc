if [ "$TRAVIS" != "true" ]; then
    echo "Invalid environment: I'm expecting Travis CI here..." >&2
    exit 1
fi
if [ -z "$PICO_TOOLS_DIR" ]; then
    echo "Invalid environment: Required environment variable 'PICO_TOOLS_DIR' not set" >&2
    exit 1
fi

function __picocms_cmd {
    echo "\$" "$@"
    "$@"
    return $?
}

# add tools to $PATH
export PATH="$PICO_TOOLS_DIR:$PATH"

# set environment variables
__picocms_cmd export PICO_BUILD_ENV="travis"

__picocms_cmd export PICO_PROJECT_DIR="$TRAVIS_BUILD_DIR"
__picocms_cmd export PICO_BUILD_DIR="$HOME/__picocms_build"
__picocms_cmd export PICO_DEPLOY_DIR="$HOME/__picocms_deploy"

__picocms_cmd export PICO_DEPLOYMENT="${TRAVIS_BRANCH//\//_}"

__picocms_cmd export PROJECT_REPO_SLUG="$TRAVIS_REPO_SLUG"
__picocms_cmd export PROJECT_REPO_COMMIT="$TRAVIS_COMMIT"

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    __picocms_cmd export PROJECT_REPO_BRANCH="$TRAVIS_BRANCH"

    __picocms_cmd export PROJECT_REPO_PR="$TRAVIS_PULL_REQUEST"
    __picocms_cmd export PROJECT_REPO_PR_SLUG="$TRAVIS_PULL_REQUEST_SLUG"
    __picocms_cmd export PROJECT_REPO_PR_COMMIT="$TRAVIS_PULL_REQUEST_SHA"
    __picocms_cmd export PROJECT_REPO_PR_BRANCH="$TRAVIS_PULL_REQUEST_BRANCH"
elif [ -n "$TRAVIS_TAG" ]; then
    __picocms_cmd export PROJECT_REPO_TAG="$TRAVIS_TAG"
else
    __picocms_cmd export PROJECT_REPO_BRANCH="$TRAVIS_BRANCH"
fi
