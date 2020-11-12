
cmake_ninja_install() {
  local command_prefix=(
    nice -n 20
    ionice -c 3
  )
  local environment=(
    NINJA_STATUS="[%u/%r/%f] "
    DESTDIR="${image_dir}"
  )

  rm -rf "${image_dir}"

  local target
  if [ -n "debug" ]; then
    target="install"
  else
    target="install/strip"
  fi

  command_prefix+=(env "${environment[@]}")
  time "${command_prefix[@]}" \
      ninja -C "${build_dir}" "${target}"
}
