#!/bin/bash -Eeu

source "${SH_DIR}/augmented_docker_compose.sh"

#- - - - - - - - - - - - - - - - - - - - - - - -
build_tagged_images()
{
  build_images "${@:-}"
  tag_images_to_latest "${@:-}"
  check_embedded_env_var
}

#- - - - - - - - - - - - - - - - - - - - - - - -
build_images()
{
  if [ "${1:-}" == server ]; then
    local -r target=downloader
  fi	
  augmented_docker_compose \
    build \
    --build-arg COMMIT_SHA=$(git_commit_sha) ${target:-}
}

#- - - - - - - - - - - - - - - - - - - - - - - -
tag_images_to_latest()
{
  docker tag ${CYBER_DOJO_DOWNLOADER_IMAGE}:$(image_tag)        ${CYBER_DOJO_DOWNLOADER_IMAGE}:latest
  if [ "${1:-}" != server ]; then
    docker tag ${CYBER_DOJO_DOWNLOADER_CLIENT_IMAGE}:$(image_tag) ${CYBER_DOJO_DOWNLOADER_CLIENT_IMAGE}:latest
  fi
  echo
  echo "echo CYBER_DOJO_DOWNLOADER_SHA=$(git_commit_sha)"
  echo "echo CYBER_DOJO_DOWNLOADER_TAG=$(image_tag)"
  echo
}

# - - - - - - - - - - - - - - - - - - - - - -
check_embedded_env_var()
{
  if [ "$(git_commit_sha)" != "$(sha_in_image)" ]; then
    echo "ERROR: unexpected env-var inside image $(image_name):$(image_tag)"
    echo "expected: 'SHA=$(git_commit_sha)'"
    echo "  actual: 'SHA=$(sha_in_image)'"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${ROOT_DIR}" && git rev-parse HEAD)
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo "${CYBER_DOJO_DOWNLOADER_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_sha()
{
  echo "${CYBER_DOJO_DOWNLOADER_SHA}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_tag()
{
  echo "${CYBER_DOJO_DOWNLOADER_TAG}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
sha_in_image()
{
  docker run --rm $(image_name):$(image_tag) sh -c 'echo -n ${SHA}'
}
