#!/bin/bash

ARGS=""
LOCAL_REGISTRY="http://nvy-registry:4873"

pre() {
  export TIMEFORMAT="%R"
  cd cra-app
  rm -rf node_modules
}

post() {
  cd ..
}

npm-install() {
  time (npm install $ARGS &> /dev/null) 
}

npm-ci() {
  time (npm ci $ARGS &> /dev/null)
}

yarn-install() {
  time (yarn install $ARGS &> /dev/null)
}

yarn-install-fl() {
  time (yarn install --frozen-lockfile $ARGS &> /dev/null)
}

p1-T() {
  npm config set registry $LOCAL_REGISTRY &> /dev/null
  yarn config set registry $LOCAL_REGISTRY &> /dev/null
  cp package-lock.local.json package-lock.json
  cp yarn.local.lock yarn.lock
}

p1-F() {
  cp package-lock.remote.json package-lock.json
  cp yarn.remote.lock yarn.lock
}

p2-T() {
  if [[ $1 == *"npm"* ]]; then
    tar zxvf npm-node_modules.tar.gz &> /dev/null
  fi
  
  if [[ $1 == *"yarn"* ]]; then
    tar zxvf yarn-node_modules.tar.gz &> /dev/null
  fi
}

p2-F() {
  :
}

p3-T() {
  tar zxvf npm-cache.tar.gz -C / &> /dev/null
  tar zxvf yarn-cache.tar.gz -C / &> /dev/null
}

p3-F() {
  :
}

p4-T() {
  ARGS="--prefer-offline"
}

p4-F() {
  :
}

run-c0() {
  npm install $ARGS &> /dev/null
  tar zcvf npm-node_modules.tar.gz node_modules &> /dev/null
  tar zcvf npm-cache.tar.gz /root/.npm &> /dev/null
  rm -rf node_modules
  yarn install $ARGS &> /dev/null
  tar zcvf yarn-cache.tar.gz /usr/local/share/.cache/yarn/v6 &> /dev/null
  tar zcvf yarn-npm_node_modules.tar.gz node_modules &> /dev/null
}

run-c1() {
  p1-F
  p2-F $1
  p3-F
  p4-F
}

run-c2() {
  p1-T
  p2-F $1
  p3-F
  p4-F
}

run-c3() {
  p1-F
  p2-T $1
  p3-F
  p4-F
}

run-c4() {
  p1-T
  p2-T $1
  p3-F
  p4-F
}

run-c5() {
  p1-T
  p2-F $1
  p3-T
  p4-F
}

run-c6() {
  p1-T
  p2-T $1
  p3-T
  p4-F
}

run-c7() {
  p1-T
  p2-T $1
  p3-F
  p4-T
}

run-c8() {
  p1-T
  p2-T $1
  p3-T
  p4-T
}

main() {
  pre
  run-${1:0:2} $1
  ${1:3}
  post
}

main "$@"

