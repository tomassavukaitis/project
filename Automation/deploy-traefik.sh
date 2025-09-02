cd ../Charts/Traefik

helm upgrade --install traefik ./Traefik --namespace hello-ns --create-namespace