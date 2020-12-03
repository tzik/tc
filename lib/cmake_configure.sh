
cmake_configure() {
  local command_prefix=(
    nice -n 20
    ionice -c 3
  )
  local environment=()

  local opts=(
    -G "Ninja"
    -S "${cmake_root_dir:-${src_dir}}"
    -B "${build_dir}"
    -Wno-dev
    "-DCMAKE_INSTALL_PREFIX=${prefix}"
    "-DCMAKE_INSTALL_LIBDIR=${prefix}/lib"
    "-DCMAKE_INSTALL_RPATH=\$ORIGIN/../lib"
    "-DCMAKE_C_COMPILER_TARGET=x86_64-pc-linux-gnu"
    "-DCMAKE_CXX_COMPILER_TARGET=x86_64-pc-linux-gnu"
    "-DCMAKE_PREFIX_PATH=${prefix}"
  )

  if [ -n "${debug}" ]; then
    opts+=("-DCMAKE_BUILD_TYPE=Debug")
  else
    opts+=("-DCMAKE_BUILD_TYPE=Release")
  fi

  if [ -z "${no_ccache}" ]; then
    opts+=("-DCMAKE_C_COMPILER_LAUNCHER=ccache")
    opts+=("-DCMAKE_CXX_COMPILER_LAUNCHER=ccache")
    environment+=("CCACHE_DIR=${cache_dir}/ccache" "${command_prefix}")
  fi

  command_prefix+=(env "${environment[@]}")
  time "${command_prefix[@]}" \
      cmake "${opts[@]}" "$@"
}
