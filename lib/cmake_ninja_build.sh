
cmake_ninja_build() {
  local command_prefix=(
    nice -n 20
    ionice -c 3
  )
  local environment=(
    NINJA_STATUS="[%u/%r/%f] "
  )

  if [ -z "${no_ccache}" ]; then
    environment+=("CCACHE_DIR=${cache_dir}/ccache")
    CCACHE_DIR="${cache_dir}/ccache" ccache -z
  fi

  command_prefix+=(env "${environment[@]}")
  time "${command_prefix[@]}" \
      ninja -d keeprsp -C "${build_dir}" "$@"

  if [ -z "${no_ccache}" ]; then
    CCACHE_DIR="${cache_dir}/ccache" ccache -s
  fi
}
