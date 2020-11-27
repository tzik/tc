
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
    ccache=(env "CCACHE_DIR=${cache_dir}/ccache" ccache)
    "${ccache[@]}" -z
    local prev_cache_size="$("${ccache[@]}" --print-stats | sed -n 's/^cache_size_kibibyte\t\(.*\)$/\1/p')"
  fi

  command_prefix+=(env "${environment[@]}")
  time "${command_prefix[@]}" \
      ninja -d keeprsp -C "${build_dir}" "$@"

  if [ -z "${no_ccache}" ]; then
    "${ccache[@]}" -s

    if [ -z "${full_build}" ]; then
      return 0
    fi

    local cur_cache_size=0
    local cache_hit=0
    local cache_miss=0
    local k v
    while IFS=$'\t' read k v; do
      case "${k}" in
        cache_size_kibibyte)
          cur_cache_size="${v}"
          ;;
        direct_cache_hit|preprocessed_cache_hit)
          cache_hit="$((${cache_hit} + ${v}))"
          ;;
        cache_miss)
          cache_miss="${v}"
          ;;
        *)
          ;;
      esac
    done < <("${ccache[@]}" --print-stats)

    local cache_size_diff="$((${cur_cache_size} - ${prev_cache_size}))"
    if [ "${cache_size_diff}" -lt 0 ] || [ "${cache_hit}" -eq 0 ]; then
      return 0
    fi

    if [ "$((${cache_hit}))" -gt "$(((${cache_hit} + ${cache_miss}) * 9 / 10))" ]; then
      return 0
    fi

    local estimated_sufficient_size="$((${cache_size_diff} * (${cache_hit} + ${cache_miss}) / ${cache_miss}))"
    if [ "${cur_cache_size}" -lt  "${estimated_sufficient_size}" ]; then
      return 0
    fi

    local extra_size="$((${cur_cache_size} - ${estimated_sufficient_size}))"
    local target_size="$((${estimated_sufficient_size} + ${extra_size} * 4 / 5))"
    CCACHE_MAXSIZE="${target_size}Ki" "${ccache[@]}" -c
  fi
}
