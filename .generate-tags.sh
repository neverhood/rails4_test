#! /bin/sh
ctags -e --languages=ruby,javascript --exclude=.git --exclude='*.log' -R * `bundle show --paths` 
