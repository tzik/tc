
pack() {
  mkdir -p "${image_dir}${prefix}" "$(dirname "${image_dir}${metadata_file}")"
  cd "${image_dir}${prefix}"

  cat > "${image_dir}${metadata_file}.unmerge" <<EOF
#!/bin/bash
prefix=$(printf "%q" "${prefix}")
while read -d $'\0' i; do
  file="\$(realpath -s "\${prefix}/\${i}")"
  if [ -d "\${file}" ]; then
    rmdir --ignore-fail-on-non-empty -- "\${file}"
  else
    rm -f -- "\${file}"
  fi
done < $(printf "%q" "${metadata_file}")
EOF
  chmod a+x "${image_dir}${metadata_file}.unmerge"

  find . -depth -print0 > "${image_dir}${metadata_file}"

  rm -f "${package_file}"
  tar caf "${package_file}" -C "${image_dir}${prefix}" \
      --no-recursion --null -T "${image_dir}${metadata_file}"
}
