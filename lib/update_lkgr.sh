
update_lkgr() {
  local IFS=$'\t'

  exec {fd}> "${repo_file}.tmp"
  while read dest_rel url branch hash; do
    local dest="${base_dir}/${dest_rel}"

    mkdir -p "${dest}"
    cd "${dest}"
    if [ ! -e ".git" ]; then
      git init
      git remote add origin "${url}"
    fi

    local new_hash="$(git ls-remote -h origin "${branch}" | head -n1 | cut -f1)"
    printf "%s\t%s\t%s\t%s\n" "${dest_rel}" "${url}" "${branch}" "${new_hash}" >&${fd}
  done < "${repo_file}"
  mv "${repo_file}.tmp" "${repo_file}"
}
