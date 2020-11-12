
checkout() {
  local IFS=$'\t'
  while read dest_rel url branch hash; do
    local dest="${base_dir}/${dest_rel}"
    mkdir -p "${dest}"
    if [ ! -e "${dest}/.git" ]; then
      git init "${dest}"
    fi
    cd "${dest}"

    if ! git remote get-url origin > /dev/null; then
      git remote add origin "${url}"
    else
      git remote set-url origin "${url}"
    fi

    if ! git ls-tree "${hash}" > /dev/null; then
      git fetch --depth=1 origin "${hash}"
    fi

    local gitconfig="${base_dir}/etc/gitconfig/${dest_rel}"
    if [ -f "${gitconfig}" ]; then
      git config --unset "include.path" "${gitconfig}" || true
      git config --add "include.path" "${gitconfig}"
    fi
    git checkout -f "${hash}"
    git submodule update -f --init --depth=1 --recursive
  done < "${repo_file}"
}
