#!/bin/sh


kubectl create namespace traefik

helm repo update

helm install --namespace=traefik traefik traefik/traefik --values=values.yaml
