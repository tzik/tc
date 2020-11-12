set -ex -o pipefail

cd "$(dirname "$0")/.."
base_dir="${PWD}"
pkg_name="$(basename "${base_dir}")"
repo_file="${base_dir}/repo"

src_dir="${base_dir}/src"
cmake_root_dir="${src_dir}/llvm"
build_dir="${base_dir}/build"
: "${cache_dir:="${base_dir}/cache"}"
image_dir="${base_dir}/image"

tc_dir="$(realpath -L "${base_dir}/../..")"
lib_dir="${tc_dir}/lib"
: "${prefix:="${tc_dir}/out"}"

metadata_file="${prefix}/pkg/${pkg_name}"
package_file="${base_dir}/${pkg_name}.tar"
log_file="${base_dir}/log"
