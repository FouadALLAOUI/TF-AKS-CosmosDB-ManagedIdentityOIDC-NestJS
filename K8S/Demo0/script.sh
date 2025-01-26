kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml

#helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx -

kubectl get service ingress-nginx-controller --namespace=ingress-nginx

kubectl create ingress demo --class=nginx --rule [DNS_NAME]/=demo:80


kubectl apply -f aks-helloworld-one.yaml --namespace ingress-nginx
kubectl apply -f aks-helloworld-two.yaml --namespace ingress-nginx


kubectl get pods --namespace ingress-nginx


kubectl apply -f hello-world-ingress.yaml --namespace ingress-nginx


kubectl get ingress --namespace ingress-nginx  


kubectl get all --namespace ingress-nginx


