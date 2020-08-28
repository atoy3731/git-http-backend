#!/bin/sh

create_repo(){
  REPO_NAME="$1"
  REPO_PATH="/git/${REPO_NAME}.git"
  if [ -d "${REPO_PATH}" ]; then
    cd /git; git init --bare ${REPO_NAME}.git; cd ${REPO_PATH}; git config http.receivepack true
    chown -R root:root ${REPO_PATH}
    echo "[git-http] created ${REPO_PATH}"
  fi
}

if [ ! -z "${INIT_REPOS}" ];then
  for i in $(echo ${INIT_REPOS} | tr "," "\n")
  do
    create_repo ${i}
    #echo "hello! ${i}"
  done
else
  echo "[git-http] env INIT_REPOS is empty. skipping initial creation"
fi

# launch fcgiwrap via spawn-fcgi; launch nginx in the foreground
# so the container doesn't die on us; supposedly we should be
# using supervisord or something like that instead, but this
# will do
spawn-fcgi -s /run/fcgi.sock /usr/bin/fcgiwrap && \
    nginx -g "daemon off;"
## TODO: add loggging to stdout here
