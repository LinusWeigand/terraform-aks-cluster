kubectl create namespace keycloak

kubectl apply -f keycloak.yaml --namespace keycloak

kubectl apply -f keycloak-gatekeeper.yaml --namespace keycloak
