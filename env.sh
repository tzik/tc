tc_dir="$(realpath -L "$(dirname "${BASH_SOURCE:-$0}")")"
export PATH="${tc_dir}/out/bin:${PATH}"

get_site_packages() {
  local i
  python -c $'import site\nfor s in site.getsitepackages(): print(s)' | \
    head -n1 | \
    sed -n 's:^.*/\([^/]*/site-packages\)$:\1:p'
}
export PYTHONPATH="${tc_dir}/out/lib/$(get_site_packages):${PYTHONPATH}"
