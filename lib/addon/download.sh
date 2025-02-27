#!/usr/bin/env bash

## Get download mode based on input filename
## usage: `kc_asdf_download_mode 'test.tar.gz'`
## output: git|file|archive|package|custom
kc_asdf_download_mode() {
  local ns="download-mode.addon"
  local filename="$1"
  local mode="file"

  if [ -z "$filename" ]; then
    mode="custom"
  elif echo "$filename" | grep -qiE "\.git$"; then
    mode="git"
  elif echo "$filename" | grep -qiE "(\\.zip)$"; then
    mode="archive"
  fi

  kc_asdf_debug "$ns" "download mode of %s is %s" \
    "$filename" "$mode"
  printf "%s" "$mode"
}

## get current channel based on input tag (either stable or beta)
## usage: `channel="$(kc_asdf_download_channel "v1.0.0")"`
## limitation: due to the config, all non-stable channel will always be 'beta'
kc_asdf_download_channel() {
  local input="$1"
  local query='(-src|-dev|-latest|-stm|[-\.]rc|-alpha|-beta|[-\.]pre|-next|snapshot|master)'

  ## Empty string is not stable version
  if [ -z "$input" ]; then
    printf 'unknown'
    return 0
  fi

  ## Matched with non-stable version
  if printf '%s' "$input" | grep -qiE "$query"; then
    printf 'beta'
    return 0
  fi

  printf 'stable'
}
