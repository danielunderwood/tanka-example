#!/bin/bash

set +e

# There doesn't seem to be a great way to manage secrets with Tanka,
# so this script will set up what we need
github_oauth() {
    client_id_b64="$(gopass show github-oauth | yq -r '.client_id' | base64)"
    client_secret_b64="$(gopass show github-oauth | yq -r '.client_secret' | base64)"
    kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
type: Opaque
metadata:
    name: github-oauth
    namespace: monitoring
data:
    client_id: "$client_id_b64"
    client_secret: "$client_secret_b64"
EOF
}

github_oauth