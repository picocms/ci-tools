#!/usr/bin/env bash
set -e

# setup build system
echo "Installing build dependencies..."
echo

while [ $# -gt 0 ]; do
    case "$1" in
        "--cloc")
            echo "Installing cloc..."
            curl --location --output "$PICO_TOOLS_DIR/cloc" \
                "https://github.com/AlDanial/cloc/releases/download/1.84/cloc-1.84.pl"
            chmod +x "$PICO_TOOLS_DIR/cloc"
            ;;

        "--phpdoc")
            echo "Installing phpDocumentor..."
            curl --location --output "$PICO_TOOLS_DIR/phpdoc" \
                "https://github.com/phpDocumentor/phpDocumentor/releases/download/v2.9.1/phpDocumentor.phar"
            chmod +x "$PICO_TOOLS_DIR/phpdoc"
            ;;

        "--phpdoc3")
            echo "Installing phpDocumentor..."
            curl --location --output "$PICO_TOOLS_DIR/phpdoc" \
                "https://github.com/phpDocumentor/phpDocumentor/releases/latest/download/phpDocumentor.phar"
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
