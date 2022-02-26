#!/bin/bash
# ci-tools -- setup.sh
# Downloads and setup tools from @picocms's `ci-tools` collection.
#
# This file is part of Pico, a stupidly simple, blazing fast, flat file CMS.
# Visit us at https://picocms.org/ for more info.
#
# Copyright (c) 2022  Daniel Rudolf <https://www.daniel-rudolf.de>
#
# This work is licensed under the terms of the MIT license.
# For a copy, see LICENSE file or <https://opensource.org/licenses/MIT>.
#
# SPDX-License-Identifier: MIT
# License-Filename: LICENSE

CI_TOOLS_REPO="https://github.com/picocms/ci-tools.git"

GIT_DIR="$1"
[ -n "$GIT_DIR" ] || GIT_DIR="$(mktemp -d)"

echo "Cloning 'ci-tools' repository from '$CI_TOOLS_REPO'..."
git clone --depth=1 "$CI_TOOLS_REPO" "$GIT_DIR"

COMMIT_SHA="$(git -C "$GIT_DIR" show -s --format=%h HEAD)"
COMMIT_DATE="$(git -C "$GIT_DIR" show -s --format=%ci HEAD)"
echo "Using CI tools as of commit $COMMIT_SHA from $COMMIT_DATE"

echo "Setting 'CI_TOOLS_PATH' environment variable: $GIT_DIR/src"
export CI_TOOLS_PATH="$GIT_DIR/src"
