tc_dir="$(realpath -L "$(dirname "${BASH_SOURCE:-$0}")")"

declare -A tc_paths
tc_paths[PATH]="${tc_dir}/out/bin"
tc_paths[PYTHONPATH]="${tc_dir}/out/lib/$(python -c $'import site\nfor s in site.getsitepackages(): print(s)' | \
    head -n1 | \
    sed -n 's:^.*/\([^/]*/site-packages\)$:\1:p')"

tc_off() {
  local k v
  local IFS=":"
  for k in "${(k)tc_paths[@]}"; do
    local updated=()
    while read -d":" v; do
      if [ -n "${v}" -a "${v}" != "${tc_paths[$k]}" ]; then
        updated+=("${v}")
      fi
    done < <(eval "echo \"\${$k}:\"")
    eval "$k=\"${updated[*]}\""
  done
}

tc_on() {
  tc_off

  local k
  for k in "${(k)tc_paths[@]}"; do
    local old="$(eval "echo \${$k}")"
    if [ -n "${old}" ]; then
      old=":${old}"
    fi
    eval "export $k=\"${tc_paths[$k]}${old}\""
  done
}
