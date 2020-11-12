
cmake_ninja_pack() {
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

  # rpath_fix() {
  #   local target="$1"
  #   local value="$2"
  #   if [ ! -d "${target}" ]; then
  #     return 0
  #   fi

  #   local i
  #   find "${target}" -type f -print0 | \
  #     while read -d $'\0' i; do
  #       if [ -z "$(patchelf --print-rpath "$i" 2> /dev/null)" ]; then
  #         continue
  #       fi

  #       patchelf --force-rpath --set-rpath "${value}" "$i"
  #     done
  # }

  # if [ -z "${no_rpath_fix:-}" ] && which patchelf > /dev/null 2>&1; then
  #   rpath_fix "${image_dir}${prefix}/bin" '$ORIGIN/../lib:$ORIGIN/../lib64'
  #   rpath_fix "${image_dir}${prefix}/libexec" '$ORIGIN/../lib:$ORIGIN/../lib64'
  #   rpath_fix "${image_dir}${prefix}/lib" '$ORIGIN'
  #   rpath_fix "${image_dir}${prefix}/lib64" '$ORIGIN'
  # fi

  rm -f "${package_file}"
  tar caf "${package_file}" -C "${image_dir}${prefix}" \
      --no-recursion --null -T "${image_dir}${metadata_file}"
}
