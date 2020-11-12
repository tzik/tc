
fetch() {
  local repo="${1%@*}"
  local dest="$2"

  mkdir -p "${dest}"
  if [ ! -e "${dest}/.git" ]; then
    local opts=("--depth=1")
    if [ "${#repo}" -ne "${#1}" ]; then
      opts+=("-b" "${1:$((${#repo}+1))}")
    fi
    git clone "${opts[@]}" "${repo}" "${dest}"
  fi

  cd "${dest}"
  git submodule update --init --recursive -f --depth=1
}
