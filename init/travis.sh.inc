if [ "$TRAVIS" != "true" ]; then
    echo "Invalid environment: I'm expecting Travis CI here..." >&2
    exit 1
fi

# add tools to $PATH
export PATH="$PICO_TOOLS_DIR:$PATH"

# set environment variables
export PICO_PROJECT_DIR="$TRAVIS_BUILD_DIR"
export PICO_BUILD_DIR="$HOME/__picocms_build"
export PICO_DEPLOY_DIR="$HOME/__picocms_deploy"

export PICO_DEPLOYMENT="${TRAVIS_BRANCH//\//_}"

export PROJECT_REPO_SLUG="$TRAVIS_REPO_SLUG"
export PROJECT_REPO_COMMIT="$TRAVIS_COMMIT"

if [ -z "$TRAVIS_TAG" ]; then
    export PROJECT_REPO_BRANCH="$TRAVIS_BRANCH"
    export PROJECT_REPO_TAG=""
else
    export PROJECT_REPO_BRANCH=""
    export PROJECT_REPO_TAG="$TRAVIS_TAG"
fi

[ -n "$RELEASE_REPO_SLUG" ] || export RELEASE_REPO_SLUG="$TRAVIS_REPO_SLUG"
[ -n "$RELEASE_REPO_BRANCH" ] || export RELEASE_REPO_BRANCH="master"

[ -n "$DEPLOY_REPO_SLUG" ] || export DEPLOY_REPO_SLUG="$TRAVIS_REPO_SLUG"
[ -n "$DEPLOY_REPO_BRANCH" ] || export DEPLOY_REPO_BRANCH="gh-pages"
