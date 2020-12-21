#!/bin/sh -l

GO111MODULE=on
R3V=v1.3.0
OPERATOR_NAME=memcached-operator
OPERATOR_INSTALL_DIR=$GITHUB_WORKSPACE/installsdk
CRD_KIND=Memcached
CRD_GROUP=cache
CRD_VERSION=v1alpha1
CRD_DOMAIN=example.com
OPERATOR_REPO=github.com/holdeneoneal/giddy
env

# First parm should be sdk version
function install_sdk {
  echo "Install operator-sdk: " $1
  if [ $1 == $R3V ]; then
    export ARCH=$(case $(arch) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(arch) ;; esac)
    export OS=$(uname | awk '{print tolower($0)}')
    export OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/latest/download
    curl -LO ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH}
    chmod +x operator-sdk_${OS}_${ARCH} && mv operator-sdk_${OS}_${ARCH} /usr/local/bin/operator-sdk-$1
  else
    curl -LO https://github.com/operator-framework/operator-sdk/releases/download/$1/operator-sdk-$1-x86_64-linux-gnu
    chmod +x operator-sdk-$1-x86_64-linux-gnu && mkdir -p /usr/local/bin/ && cp operator-sdk-$1-x86_64-linux-gnu /usr/local/bin/operator-sdk-$1 && rm operator-sdk-$1-x86_64-linux-gnu
  fi
  operator-sdk-$1 version
}

# First parm should be sdk version
function init_api {
  echo "Initializing API for operator-sdk version: " $1
  mkdir -p $OPERATOR_INSTALL_DIR/$1/$OPERATOR_NAME
  echo "Created $OPERATOR_INSTALL_DIR/$1/$OPERATOR_NAME"
  cd $OPERATOR_INSTALL_DIR/$1/$OPERATOR_NAME
  operator-sdk-$1 init --domain=$CRD_DOMAIN --repo=$OPERATOR_REPO/$OPERATOR_NAME
  operator-sdk-$1 create api --group=$CRD_GROUP --version=$CRD_VERSION --kind=$CRD_KIND --resource=true --controller=true
  echo "Opeartor created at:" $OPERATOR_INSTALL_DIR/$1/$OPERATOR_NAME
}

install_sdk $OPERATOR_SDK_VERSION
init_api $OPERATOR_SDK_VERSION
echo "ENTRYPOINT complete"