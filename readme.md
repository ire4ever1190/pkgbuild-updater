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

Currently I haven't made a PKGBUILD for this (ironic) so just download the script and put it where you want
