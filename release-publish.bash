#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]

Script description here.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  return 0
}

parse_params "$@"
setup_colors

readonly BLD_PUBLISH_DIRECTORY=buildscript-${BLD_RELEASE_VERSION-}

msg "=== Installing necessary packages"
apt update && apt install build-essential zip -y

cd /

msg "=== Making directory ${BLD_PUBLISH_DIRECTORY-}"
mkdir -p "${BLD_PUBLISH_DIRECTORY-}"

msg "=== Copying files into ${BLD_PUBLISH_DIRECTORY-}"
cp -a app/* "${BLD_PUBLISH_DIRECTORY-}"

msg "=== Compressing files"
zip -q -r9 "buildscript-${BLD_RELEASE_VERSION-}.zip" "${BLD_PUBLISH_DIRECTORY-}"/

du -sch "${BLD_PUBLISH_DIRECTORY-}"/ "buildscript-${BLD_RELEASE_VERSION-}.zip"

if [[ -n $BLD_RELEASE_TOKEN ]]; then
  curl -L -O https://github.com/tfausak/github-release/releases/latest/download/github-release-linux.gz
  gunzip github-release-linux.gz && chmod 700 github-release-linux && \
  ./github-release-linux upload \
  --token "${BLD_RELEASE_TOKEN-}" \
  --owner "${BLD_RELEASE_OWNER-}" \
  --repo "${BLD_RELEASE_REPO-}" \
  --tag "v${BLD_RELEASE_VERSION-}" \
  --file "buildscript-${BLD_RELEASE_VERSION-}.zip" \
  --name "buildscript-${BLD_RELEASE_VERSION-}.zip"
else
  echo "=== No BLD_RELEASE_TOKEN configured, not pushing release artifacts to GitHub Releases"
fi
