#### TP3: GESTION DU RESEAU (minikube et [eazylabs](http://docker.labs.eazytraining.fr/)) 

```bash 
# afficher les pods avec leur label 
kubectl get po --show-labels 
# filter les pods pour afficher ceux donc le label app=nginx et contenu dans le l'espace de nom production
kubectl get pods -l app=nginx --namespace=production
```


#####################   Creation des Manifestes   #####################

```bash 
kubectl create namespace production --dry-run=client -o yaml > namespace.yml
```
```bash 
kubectl run --image=mmumshad/simple-webapp-color --env="APP_COLOR=red"   simple-webapp-color-red --labels='app=web' -n production --port=8080 --dry-run=client -o yaml > pod-red.yml
```
```bash 
kubectl run --image=mmumshad/simple-webapp-color --env="APP_COLOR=blue"   simple-webapp-color-blue --labels='app=web' -n production --port=8080 --dry-run=client -o yaml > pod-blue.yml
```
```bash 
kubectl create service nodeport  service-nodeport-web  --node-port=30008 --tcp=8080:8080 -n production --dry-run=client -o yaml > service-nodeport-web.yml
```
mettre à jour la valeur selecteur app avec ```bash web```dans service-nodeport-web.yml

#####################   Lancement et verification du namespace   #####################

```bash 
kubectl apply -f namespace.yml
```
```bash 
kubectl get namespace
```

#####################   Lancement et verification des pods et du service nodeport   #####################

```bash
kubectl apply -f pod-red.yml
```
```bash
kubectl get po  -n production -o wide
```
```bash
kubectl apply -f pod-blue.yml
```
```bash
kubectl get po  -n production -o wide
```
```bash
kubectl apply -f service-nodeport-web.yml
```

Faisons un fowarding du service nodeport
```bash
kubectl port-forward -n production service/service-nodeport-web 30008:8080 --address 0.0.0.0
```
```bash
kubectl get service  -n production -o wide
```
```bash
kubectl -n production describe svc service-nodeport-web
```

#####################   Suppression des pods, service nodeport et du namespace   #####################

```bash
kubectl delete -f pod-red.yml
```
```bash
kubectl delete -f pod-blue.yml
```
```bash
kubectl delete -f service-nodeport-web.yml
```
```bash
kubectl delete -f namespace.yml
```