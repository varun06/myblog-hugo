#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# delete the public directory if exists.
# rm -rf public

# create a submodule for deployment
# git submodule add git@github.com:varun06/varun06.github.io.git public

# Build the project.
hugo -t casper # if using a theme, replace by `hugo -t <yourtheme>`

# Go To Public folder
cd public
# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back
cd ..

# delete the submodule as I am having issue with deployment.
# git submodule deinit public
# git rm public
# git rm --cached public
# rm -rf .git/modules/public