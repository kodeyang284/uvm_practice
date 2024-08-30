#!/bin/sh

if [[ -n $1 ]]; then
  [[ ! $(grep -E '^\s{2}\w' "$1") ]] && \
    [[ $(grep -E '^\s{3}\w' "$1") ]] && \
      sed -E -i 's/(\s{3})/  /g' "$1" && \
        echo "fix "$1" indent to indent 2"
else
  echo "fix a single 3 indents file to 2 indents. it only works in the 3 indents file."
fi

