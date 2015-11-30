#!/bin/bash
msg="update blog"
if [ $# -eq 1 ]
  then msg="$1"
fi
git add -A && git commit -m "$msg" && git push origin master
hugo
cd public/
git add -A && git commit -m "$msg" && git push origin master
cd ../
