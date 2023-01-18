#!/bin/sh

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubetctl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"