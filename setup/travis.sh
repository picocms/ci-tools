#!/usr/bin/env bash
set -e

# setup build system
echo "Installing build dependencies..."
echo

while [ $# -gt 0 ]; do
    if [ "$1" == "--cloc" ]; then
        echo "Synchronizing package index files..."
        sudo apt-get update || true
        echo
    fi

    case "$1" in
        "--cloc")
            echo "Installing cloc..."
            sudo apt-get install -y cloc
            ;;

        "--phpdoc")
            echo "Installing phpDocumentor..."
            curl --location --output "$PICO_TOOLS_DIR/phpdoc" \
                "https://github.com/phpDocumentor/phpDocumentor2/releases/latest/download/phpDocumentor.phar"
            chmod +x "$PICO_TOOLS_DIR/phpdoc"
            ;;

        "--phpcs")
            echo "Installing PHP_CodeSniffer..."
            if [ "$(php -r 'echo PHP_VERSION_ID;')" -ge 50400 ]; then
                PHPCS_DOWNLOAD="https://github.com/squizlabs/PHP_CodeSniffer/releases/latest/download/"
            else
                PHPCS_DOWNLOAD="https://github.com/squizlabs/PHP_CodeSniffer/releases/download/2.9.2/"
            fi

            curl --location --output "$PICO_TOOLS_DIR/phpcs" \
                "$PHPCS_DOWNLOAD/phpcs.phar"
            chmod +x "$PICO_TOOLS_DIR/phpcs"

            curl --location --output "$PICO_TOOLS_DIR/phpcbf" \
                "$PHPCS_DOWNLOAD/phpcbf.phar"
            chmod +x "$PICO_TOOLS_DIR/phpcbf"
            ;;

        *)
            echo "Unknown build dependency: $1" >&2
            exit 1
    esac

    echo
    shift
done

# let composer use our GITHUB_OAUTH_TOKEN
if [ -n "$GITHUB_OAUTH_TOKEN" ]; then
    echo "Setting up GitHub OAuth token for Composer..."
    composer config --global github-oauth.github.com "$GITHUB_OAUTH_TOKEN"
    echo
fi
