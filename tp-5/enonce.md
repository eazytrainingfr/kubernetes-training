#### TP6: INTRODUCTION A HELM (minikube exclusivement car ce TP nécessite au moins la version 1.19 de kubernetes et la version kubernetes est 1.18 sur l'environnement [eazylabs](http://docker.labs.eazytraining.fr/)) 


https://devopscube.com/install-configure-helm-kubernetes/

recuperation du script d'installation
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
```
donnons les droits d'execution
```bash 
chmod 700 get_helm.sh
```
installation d'openssl
```bash
sudo yum install openssl
```
telechargeons helm
```bash
./get_helm.sh
```
verifions la version
```bash
helm version
```

################################    Déploiement WordPress    ################################

Lien utile
```bash
https://devopscube.com/install-configure-helm-kubernetes/
```

recuperation des charts fournit par bitnami
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```
redefinition des valeurs de deploiement de notre wordpress
https://github.com/bitnami/charts/blob/main/bitnami/wordpress/values.yaml

```bash
vi values.yml
```
ajouter du contenu suivant

```bash
wordpressUsername: admin
wordpressPassword: password
service:
  type: NodePort
  nodePorts:
    http: "30008"
persistence:
  enabled: false
mariadb:
  primary:
    persistence:
      enabled: false
```

Lancons le déploiement 
```bash
helm install wordpress bitnami/wordpress -f values.yml
```

Nettoyer l'environnement 
```bash
helm uninstall wordpress
```