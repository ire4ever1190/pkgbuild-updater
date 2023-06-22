Very basic script to update PKGBUILD files. My main usecase is updating the PKGBUILD files I maintain in the AUR.

#### Features

 - Automatically finding latest version for package (Only supports github atm)
 - Updates `pkgrel` if the version doesn't change but there are changes
 - Doesn't do anything if there are no changes
 - Automatically makes a commit message with the changes

#### Usage

Usage is just

```sh
pkgbuild-updater
git push
```

#### Installation

Install the [pkgbuild-updater](https://aur.archlinux.org/packages/pkgbuild-updater) package from the AUR.

If installing manually for some reason, this requires
- `jq`
- `pacman-contrib`
