#!/bin/sh

set -e

################################################################################
# repo
################################################################################
helm repo add datawire https://app.getambassador.io
helm repo update datawire > /dev/null

################################################################################
# chart
################################################################################
STACK="edge-stack"
CHART="datawire/edge-stack"
CHART_VERSION="7.2.2"
NAMESPACE="ambassador"

if [ -z "${MP_KUBERNETES}" ]; then
  # use local version of values.yml
  ROOT_DIR=$(git rev-parse --show-toplevel)
  values="$ROOT_DIR/stacks/ambassador/values.yml"
else
  # use github hosted master version of values.yml
  values="https://raw.githubusercontent.com/digitalocean/marketplace-kubernetes/master/stacks/ambassador/values.yml"
fi

kubectl apply -f https://app.getambassador.io/yaml/edge-stack/2.1.2/aes-crds.yaml

helm upgrade "$STACK" "$CHART" \
  --atomic \
  --create-namespace \
  --install \
  --namespace "$NAMESPACE" \
  --version "$CHART_VERSION" \
  --values "$values" \
  --timeout 10m0s
