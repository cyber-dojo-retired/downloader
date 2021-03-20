#!/bin/bash -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
echo_versioner_env_vars()
{
  docker run --rm cyberdojo/versioner:latest
  #
  echo CYBER_DOJO_DOWNLOADER_SHA="$(get_image_sha)"
  echo CYBER_DOJO_DOWNLOADER_TAG="$(get_image_tag)"
  #
  echo CYBER_DOJO_DOWNLOADER_IMAGE=cyberdojo/downloader
  echo CYBER_DOJO_DOWNLOADER_PORT=4587
  #
  echo CYBER_DOJO_DOWNLOADER_CLIENT_IMAGE=cyberdojo/client
  echo CYBER_DOJO_DOWNLOADER_CLIENT_PORT=9999
  #
  echo CYBER_DOJO_DOWNLOADER_CLIENT_USER=nobody
  echo CYBER_DOJO_DOWNLOADER_SERVER_USER=nobody
  #
  echo CYBER_DOJO_DOWNLOADER_CLIENT_CONTAINER_NAME=test_downloader_client
  echo CYBER_DOJO_DOWNLOADER_SERVER_CONTAINER_NAME=test_downloader_server
}

# - - - - - - - - - - - - - - - - - - - - - - - -
get_image_sha()
{
  echo "$(cd "${ROOT_DIR}" && git rev-parse HEAD)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
get_image_tag()
{
  local -r sha="$(get_image_sha)"
  echo "${sha:0:7}"
}
