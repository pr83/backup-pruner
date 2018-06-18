#!/bin/bash

basedir="$1"
require_root_relative="$2"
load_path="$basedir/$require_root_relative"

if [[ ! ( -d "$basedir" ) || ! ( -d "$load_path" ) ]]; then
    echo "Usage: ./get_rid_of_relatives.sh <project_base_directory> <require_root_directory_relative_to_project_base>"
    exit 1
fi

replace_line() {
  line="$1"
  if [[ "$line" =~ ^require_relative ]]; then
    relative_path=$(echo "$line" | sed 's/^require_relative .\(.*\).$/\1/')
    absolute_path=$(readlink "$relative_path" -f)
    absolute_require=.${absolute_path#${load_path}}
    echo "require '$absolute_require'"
  else
    echo "$line"
  fi
}

tempfile=$(mktemp)

cd "$basedir"

for file in $(find . -name '*.rb'); do
  includer_dirname=$(dirname "$file")
  includer_filename=$(basename "$file")

  pushd "$includer_dirname" > /dev/null
  touch "$tempfile"

  echo "Processing $(pwd)/$includer_filename"

  IFS=''
  cat "$includer_filename" | while read -r line || [ -n "$line" ]; do
    replace_line "$line" >> "$tempfile"
  done
  mv "$tempfile" "$includer_filename"

  popd > /dev/null
done
