#### TP1: COMPOSANT ET INSTALLATION DE MINIKUBE

Il est important de noter que lors de cette formation nous n'allons pas faire l'installation d'un cluster complet, nous allons travailler sur du single node ie sur un seul noeud déployé sur une VM ayant comme OS centos 7

Alors nous allons installer minikube qui est une version miniaturise de Kubernetes utilise pour les cours de formation ou pour les tests  comme dans le cadre de ce cours (https://kubernetes.io/fr/docs/setup/learning-environment/minikube/)


#### ATTENTION : POUR INSTALLER MINIKUBE IL VOUS FAUT UNE VM AVEC AU MOINS 2 GO ET 2 CPU MINIMUM, DANS NOTRE CAS NOUS SOMMES SUR CENTOS 7.9

EPEL (Extra Package for Entreprise Linux) est un dépôt qui fournit des paquets additionnels pour les distributions basées sur RedHat. En installant EPEL vous aurez un nombre conséquent de paquets disponibles via le gestionnaire de paquets yum

```bash
sudo yum -y update
sudo yum -y install epel-release
```

Ensuite on installe les paquets libvirt qemu-kvm vont permettre d'installer la VM minikube qui contient
kubernetes

```bash
 sudo yum -y install git libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils
``` 
```bash
sudo yum install socat -y  # qui permet de faire du fowarding
sudo yum install -y conntrack # qui permet de gerer l'utilisation du processeur sur notre machine par minikube
``` 

Ensuite nous allons installer Docker a partir de son script d'installation (https://get.docker.com/)

Pourquoi installer docker? Le problème est que l'on ne peut pas faire de la virtualisation sur notre VM car
elle est interdit alors pour pouvoir avoir les composants de kubernetes sur notre PC nous allons utiliser la
technologie de conteneurisation pour dire à minikube de récupérer chaque composant de Kubernetes sous forme
de conteneur comme : DNS? API SERVER? kube SCHEDULER, MANAGER et ETCD

```bash
# télécharger le script
curl -fsSL https://get.docker.com -o install-docker.sh 
# vérifier le contenu du script
cat install-docker.sh 
# exécuter le script avec --dry-run pour vérifier les étapes qu'il exécute
sh install-docker.sh --dry-run 
# exécutez le script soit en tant que root, soit en utilisant sudo pour effectuer l'installation.
sudo sh install-docker.sh 
# donner les droits d'excution sur le service docker a l'utlisateur centos
sudo usermod -aG docker centos 
# lancer le service docker
sudo systemctl start docker 
```

Ensuite nous installons minikube

```bash
# telecharger le binaire de minikube 
sudo yum -y install wget  
sudo wget https://storage.googleapis.com/minikube/releases/v1.28.0/minikube-linux-amd64
# render la cmd minikube executable partout sur la VM
sudo chmod +x minikube-linux-amd64 
sudo mv minikube-linux-amd64 /usr/bin/minikube 
```

Ensuite nous installe l'utilitaire de ligne de commande de minikube  kubectl

```bash
# doc de kubectl (https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.0/bin/linux/amd64/kubectl  
# render la cmd kubectl executable partout sur la VM 
sudo chmod +x kubectl 
sudo mv kubectl  /usr/bin/ 
```

Configurer le forwarding au niveau des interfaces reseaux

```bash
sudo su
sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
# activer le service docker au demarrage
sudo systemctl enable docker.service
# rafraichir le terminal sans se deconnecter
exec sudo su -l $USER
# lancer minikube
minikube start –driver=docker --kubernetes-version=v1.28.3
```

une fois l'installation terminé on peut lister les nodes en tapant 
Vérifier que le cluster est fonctionnel

```bash
# nous pouvons presenter les composants que minikube a telechargé en tapant 
minikube image ls
# lister les noeuds
kubectl get nodes
# lister les composants systemes
kubectl get pod -A
```
