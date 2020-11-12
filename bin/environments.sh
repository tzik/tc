work_dir="${PWD}"
base_dir="$(realpath -L "$(dirname "${BASH_SOURCE:-$0}")/..")"

passing_environments=(
  prefix
  cache_dir
)
