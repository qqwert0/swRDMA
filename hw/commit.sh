#! /bin/bash
git add . ;
if [ ! -n "$1" ] ;then
    git commit -m "$(date +%Y-%m-%d_%H:%M:%S)" ;
else
    git commit -m "$1" ;
fi

git push ;