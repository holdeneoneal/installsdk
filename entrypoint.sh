#!/bin/sh -l

GO111MODULE=on
R2V=v1.2.0
R3V=v1.3.0

# First parm should be sdk version
function install_sdk {
  echo "Download and Install operator-sdk: " $1
  if [ $1 == "v1.2.0" ]; then
    curl -LO https://github.com/operator-framework/operator-sdk/releases/download/$1/operator-sdk-$1-x86_64-linux-gnu
    chmod +x operator-sdk-$1-x86_64-linux-gnu && sudo mkdir -p /usr/local/bin/ && sudo cp operator-sdk-$1-x86_64-linux-gnu /usr/local/bin/operator-sdk-$1 && rm operator-sdk-$1-x86_64-linux-gnu
  else
    export ARCH=$(case $(arch) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(arch) ;; esac)
    export OS=$(uname | awk '{print tolower($0)}')
    export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/latest/download
    curl -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH}
    chmod +x operator-sdk_${OS}_${ARCH} && sudo mv operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk-$1
  fi
  operator-sdk-$1 version
}

# First parm should be sdk version
function init_api {
  echo "Initializing API for operator-sdk version: " $1
  mkdir -p /workspace/$1/memcached-operator
  echo "Created /workspace/$1/memcached-operator"
  cd /workspace/$1/memcached-operator
  operator-sdk-$1 init --domain=example.com --repo=github.com/holdeneoneal/giddy/memcached-operator
  operator-sdk-$1 create api --group=cache --version=v1alpha1 --kind=Memcached --resource=true --controller=true
}

install_sdk $R2V
install_sdk $R3V

init_api $R2V
init_api $R3V

echo "ENTRYPOINT complete"
# diff /workspace/$R2V/memcached-operator /workspace/$R3V/memcached-operator
