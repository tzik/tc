
merge() {
  mkdir -p "${prefix}"
  if [ -f "${package_file}" ]; then
    tar xf "${package_file}" -C "${prefix}"
  else
    tar xf "${package_file}.xz" -C "${prefix}"
  fi
}
