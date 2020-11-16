
apply_patches() {
  local i
  if [ ! -d "${base_dir}/etc/patches" ]; then
    return 0
  fi
  while read -d $'\0' i; do
    if ! patch -d "${src_dir}" -R -f -s -p1 --dry-run -i "$i" > /dev/null 2>&1; then
      echo "Applying $(basename "$i")"
      patch -d "${src_dir}" -N -f -s -p1 -i "$i"
    fi
  done < <(find "${base_dir}/etc/patches" -name '*.patch' -print0)
}

