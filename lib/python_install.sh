
python_install() {
  local setup_script="$1"
  python3 "${setup_script}" install --prefix "${prefix}" --root "${image_dir}"
}
