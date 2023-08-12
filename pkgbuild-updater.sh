#!/bin/sh
set -e
BUILD_FILE=./PKGBUILD
# Load variables from the PKGBUILD
source "$BUILD_FILE"
# Store old version so we know if we need to increment pkgrel
oldPkgver=$pkgver
echo "Updating: $pkgname"
# Find the first source URL.
# We will use that to try and find the latest version
sourceURL=$(sed -n -E "s/^source.*=\(\".*::(.*)\".*\)/\1/p" "$BUILD_FILE" | head -n 1)
case "$sourceURL" in
  https://github.com*)
    # I'm going to assume most projects will make tags.
    # Github seems to make tags in order of release so no need to sort the tags.
    # We do need to remove the 'v' prefix though
    tagsUrl=$(echo "$sourceURL" | sed -E "s@https://github.com/([^/]*)/([^/]*)/?.*@https://api.github.com/repos/\1/\2/tags@")
    pkgver=$(curl --silent "$tagsUrl" | jq -r .[0].name | sed "s/^v//")
  ;;
  # TODO: Give user option to specify version themsevles, maybe a --useVersion flag or something
  *)
    echo "Unknown source. Please make an issue or PR to add this source"
    exit 1
  ;;
esac
# Make sure we got a version
if [ -z "$pkgver" ]; then
  echo "Error when trying to get version" 1>&2
  exit 1
fi
# Update the version in the PKGBUILD
sed -i "s/^pkgver=.*/pkgver=$pkgver/" "$BUILD_FILE"
# Now we need to update the hashes
updpkgsums $BUILD_FILE
# Rebuild .SRCINFO
makepkg --printsrcinfo > .SRCINFO
# Check if we need to update pkgrel
if [[ -n "$(git status --porcelain --untracked-files=no)" && "$pkgver" == "$oldPkgver" ]]; then
  # If there was any changes but pkgver is the same, then we need to update pkgrel
  pkgrel=$(($pkgrel + 1))
elif [[ "$pkgver" != "$oldPkgver" ]]; then
  # We need to reset pkgrel to 1 if we incremented the version
  pkgrel=1
fi
echo "New version: $pkgver-$pkgrel"
sed -i "s/^pkgrel=.*/pkgrel=$pkgrel/" $BUILD_FILE
# Rebuild .SRCINFO again incase the pkgrel number changed
makepkg --printsrcinfo > .SRCINFO

# And commit the changes (Should I ask the user if the changes are a-ok?)
git commit .SRCINFO $BUILD_FILE -m "Bump to $pkgver-$pkgrel"

