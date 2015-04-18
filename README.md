# A JSPM package for Atom.

This package will add commands for installing and uninstalling JSPM packages.

![zoltu-jspm-usage](https://cloud.githubusercontent.com/assets/886059/7216582/1c40943e-e5b9-11e4-8006-d14300ba8de5.gif)

Known issues:
 * JSPM Init command doesn't work yet.
  * This is because I don't know how to do a headless init with JSPM.
 * Only tested on Windows with git installed to `C:\Program Files (x86)\Git\bin\`
  * JSPM depends on git.  I do not have git in my path so there is a helper that looks for the above directory first.  If that directory doesn't exist it falls back to just executing `git`, which should work... maybe.
