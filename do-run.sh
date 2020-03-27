#!/bin/bash                                                                                                                                            [17/58]

ARGS="--registry http://nvy-registry:4873"

pre() {
  export TIMEFORMAT="%R seconds"
  cd cra-app
  rm -rf node_modules
}

post() {
  cd ..
}

npm-install() {
  time npm install ${ARGS} $1 &> /dev/null
}

npm-ci() {
  time npm ci ${ARGS} $1 &> /dev/null
}

yarn-install() {
  time yarn install ${ARGS} $1 &> /dev/null
}

yarn-install-frozen-lockfile() {
  time yarn install --frozen-lockfile ${ARGS} $1 &> /dev/null
}

run-c1() {
  ${1:3}
}

run-c2() {
  tar zxvf node_modules.tar.gz &> /dev/null
  ${1:3}
}

run-c3() {
  tar zxvf node_modules.tar.gz &> /dev/null
  ${1:3} --prefer-offline
}

main() {
  echo $1
  pre
  run-${1:0:2} $1
  post
}

main "$@"

