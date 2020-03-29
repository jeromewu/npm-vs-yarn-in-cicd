#!/bin/bash

LOCAL_REGISTRY="http://nvy-registry:4873"
ARGS=""

pre() {
  export TIMEFORMAT="%R"
  cd cra-app
  rm -rf node_modules .pnpm-store .yarn*
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

yarn2-install() {
  yarn set version berry &> /dev/null
  time (yarn install $ARGS &> /dev/null)
}

pnpm-install() {
  npx pnpm add -g pnpm@4.12.1 &> /dev/null
  pnpm config set store-dir $PWD/.pnpm-store
  time (pnpm install $ARGS &> /dev/null)
}

p1-T() {
  ARGS="--registry $LOCAL_REGISTRY"
  cp package-lock.local.json package-lock.json
  cp yarn.local.lock yarn.lock
  cp .yarnrc.local.yml .yarnrc.yml
}

p1-F() {
  cp package-lock.remote.json package-lock.json
  cp yarn.remote.lock yarn.lock
}

p2-T() {
  if [[ $1 == *"-npm-"* ]]; then
    tar zxvf npm-node_modules.tar.gz &> /dev/null
  fi
  
  if [[ $1 == *"-yarn-"* ]]; then
    tar zxvf yarn-node_modules.tar.gz &> /dev/null
  fi
  
  if [[ $1 == *"-yarn2-"* ]]; then
    tar zxvf yarn2-cache.tar.gz &> /dev/null
  fi
  
  if [[ $1 == *"-pnpm-"* ]]; then
    tar zxvf pnpm-node_modules.tar.gz &> /dev/null
  fi
}

p2-F() {
  :
}

p3-T() {
  if [[ $1 == *"-npm-"* ]]; then
    tar zxvf npm-cache.tar.gz -C / &> /dev/null
  fi
  
  if [[ $1 == *"-yarn-"* ]]; then
    tar zxvf yarn-cache.tar.gz -C / &> /dev/null
  fi
  
  if [[ $1 == *"-yarn2-"* ]]; then
    tar zxvf yarn2-cache.tar.gz &> /dev/null
  fi
  
  if [[ $1 == *"-pnpm-"* ]]; then
    tar zxvf pnpm-cache.tar.gz &> /dev/null
  fi
}

p3-F() {
  :
}

p4-T() {
  ARGS="$ARGS --prefer-offline"
}

p4-F() {
  :
}

run-c0() {
  # npm
  npm install &> /dev/null
  tar zcvf npm-node_modules.tar.gz node_modules &> /dev/null
  tar zcvf npm-cache.tar.gz /root/.npm &> /dev/null
  rm -rf node_modules

  # pnpm
  npx pnpm add -g pnpm@4.12.1 &> /dev/null
  pnpm config set store-dir $PWD/.pnpm-store &> /dev/null
  pnpm install &> /dev/null
  pnpm install --registry $LOCAL_REGISTRY $ARGS &> /dev/null
  tar zcvf pnpm-node_modules.tar.gz node_modules &> /dev/null
  tar zcvf pnpm-cache.tar.gz .pnpm-store &> /dev/null
  rm -rf node_modules

  # yarn
  yarn install &> /dev/null
  tar zcvf yarn-cache.tar.gz /usr/local/share/.cache/yarn/v6 &> /dev/null
  tar zcvf yarn-node_modules.tar.gz node_modules &> /dev/null
  rm -rf node_modules

  # yarn2
  yarn set version berry &> /dev/null
  yarn install &> /dev/null
  tar zcvf yarn2-cache.tar.gz .yarn &> /dev/null
  rm -rf node_modules
}

run-c1() {
  p1-F
  p2-F $1
  p3-F $1
  p4-F
}

run-c2() {
  p1-T
  p2-F $1
  p3-F $1
  p4-F
}

run-c3() {
  p1-F
  p2-T $1
  p3-F $1
  p4-F
}

run-c4() {
  p1-T
  p2-T $1
  p3-F $1
  p4-F
}

run-c5() {
  p1-T
  p2-F $1
  p3-T $1
  p4-F
}

run-c6() {
  p1-T
  p2-T $1
  p3-T $1
  p4-F
}

run-c7() {
  p1-T
  p2-T $1
  p3-F $1
  p4-T
}

run-c8() {
  p1-T
  p2-T $1
  p3-T $1
  p4-T
}

main() {
  pre
  run-${1:0:2} $1
  ${1:3}
  post
}

main "$@"

