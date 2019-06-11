message=$1
echo $message
gitbook build
git add *
git commit -m "$message"
git push origin master
git subtree push --prefix=_book origin gh-pages
