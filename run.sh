#!/bin/sh

## TODO: make sure that we do not stomp any existing repos

create_repo(){
  REPO_NAME="$1"
  cd /git; git init --bare ${REPO_NAME}.git; cd /git/${REPO_NAME}.git; git config http.receivepack true
  chown -R root:root /git/${REPO_NAME}.git
  echo "[git-http] created /git/${REPO_NAME}.git"
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

spawn-fcgi -s /run/fcgi.sock /usr/bin/fcgiwrap && \
    nginx -g "daemon off;"
## TODO: add loggging to stdout here
