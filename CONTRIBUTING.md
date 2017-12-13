# Pull requests

All changes, no matter how trivial, must be done via pull request. Code shall not be pushed up to `master`, ever. 

## When you make a pull request, make sure you have done all of the following:

* Add/remove documentation to the code that you add/edit/remove. We use [jazzy](https://github.com/realm/jazzy/) for documentation for inline code documentation. 
* Generate documentation. I have always found it easiest to create a git hook for the pre-commit phase to automatically generate docs on each commit. Put the following in to a file in `VCBoss/.git/hooks/pre-commit` file:

```
#!/bin/sh
#
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# To enable this hook, rename this file to "pre-commit".

echo "-----Generating jazzy docs-----"
jazzy --podspec VCBoss.podspec
git add docs/

exit 0
```

* If you add functionality to the project, first, [open an issue](https://github.com/levibostian/VCBoss/issues/new) explaining what you wish to do in case it does not align with the project, or it has already been done. Don't want to waste your time 😄. Second, add some functionality into the Example iOS app in this project that demonstrates the functionality. 
