#### TP4: GESTION DU STOCKAGE (minikube et [eazylabs](http://docker.labs.eazytraining.fr/)) 

VOLUME
```bash
kubectl apply -f mysql-volume.yml
```
```bash
kubectl get po -o wide
```
```bash
kubectl port-forward mysql-volume 3306:3306 --address 0.0.0.0
```

APPLY VOLUME
```bash
kubectl get po -o wide
```
```bash
kubectl delete  -f mysql-volume.yml
```
```bash
kubectl get po -o wide
```

PV
```bash
kubectl apply -f pv.yml
```
```bash
kubectl get pv -o wide
```
```bash
kubectl get pv pv -o wide
```
```bash
kubectl describe  pv pv
```

PVC
```bash
kubectl apply -f pvc.yml
```
```bash
kubectl get pvc pvc -o wide
```
```bash
kubectl describe  pv pv
```

APPLY PV AND PVC
```bash
kubectl apply -f mysql-pv.yml
```
```bash
kubectl describe  po mysql-pv
```
```bash
kubectl get po
```
