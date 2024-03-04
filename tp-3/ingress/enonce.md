#### Ingress 

– liens utiles
    https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/

    https://kubernetes.github.io/ingress-nginx/deploy/#provider-specific-steps

###################################    Enable the Ingress controller    ###################################

```bash
minikube addons enable ingress
```
```bash
kubectl get pods -n ingress-nginx
```

###################################    Deploy a hello, world app    ###################################

```bash
kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0
```
```bash
kubectl expose deployment web --type=NodePort --port=8080
```
```bash
kubectl get service web
```
```bash
minikube service web --url
```

###################################    Create an Ingress Rule    ###################################

```bash
vi example-ingress.yaml
```

Copy and paste

```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
    - host: hello-world.info
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web
                port:
                  number: 8080
```

```bash
kubectl apply -f example-ingress.yaml
```

```bash
curl --resolve "hello-world.info:80:$( minikube ip )" -i http://hello-world.info
```

###################################    Create a second Deployment    ###################################

```bash
kubectl create deployment web2 --image=gcr.io/google-samples/hello-app:2.0
```

```bash
kubectl expose deployment web2 --port=8080 --type=NodePort
```

Update ingress rule

```bash
vi example-ingress.yaml
```

```bash
- path: /v2
  pathType: Prefix
  backend:
    service:
      name: web2
      port:
        number: 8080
```

```bash
kubectl apply -f example-ingress.yaml
```

```bash
curl --resolve "hello-world.info:80:$( minikube ip )" -i http://hello-world.info
```

```bash
curl --resolve "hello-world.info:80:$( minikube ip )" -i http://hello-world.info/v2
```

