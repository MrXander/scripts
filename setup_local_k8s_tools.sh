#!/bin/bash

cd
printf "We are here now: "; pwd

echo "Updating repos"
sudo apt-get update -y && sudo apt-get install -y \
bash-completion \
nmap \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common


echo "Downloading kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl && sudo mv -f ./kubectl /usr/local/bin/kubectl

echo "kubectl bash completion"
sudo rm /etc/bash_completion.d/kubectl
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null

echo "Setting cluster config"
kubectl config set-cluster fake --server=https://5.6.7.8 --insecure-skip-tls-verify
kubectl config set-credentials nobody 
kubectl config set-context fake --cluster=fake --namespace=default --user=nobody

#helm
echo "Downloading helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

echo "helm bash completion"
sudo rm /etc/bash_completion.d/helm
helm completion bash | sudo tee /etc/bash_completion.d/helm > /dev/null

echo "Install helm plugins: helm-github, helm-tiller, helm-restore"
helm repo add "stable" "https://charts.helm.sh/stable" --force-update > /dev/null
helm repo add proget http://proget.trgdev.com/helm/R1.Helm.Private

helm plugin install https://github.com/sagansystems/helm-github.git
helm plugin install https://github.com/maorfr/helm-restore
helm plugin install https://github.com/databus23/helm-diff --version master

echo "Get the kubectx script"
curl -O https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx \
&& chmod +x kubectx \
&& sudo mv -f kubectx /usr/local/bin/

echo "Get the kubens script"
curl -O https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens \
&& chmod +x kubens \
&& sudo mv -f kubens /usr/local/bin/

echo "Add the completion script to the /etc/bash_completion.d directory"
BASE_URL=https://raw.githubusercontent.com/ahmetb/kubectx/master/completion
sudo rm /etc/bash_completion.d/kubectx
sudo rm /etc/bash_completion.d/kubens
curl ${BASE_URL}/kubectx.bash | sudo tee /etc/bash_completion.d/kubectx > /dev/null
curl ${BASE_URL}/kubens.bash | sudo tee /etc/bash_completion.d/kubens > /dev/null

echo "Adding aliases alias kx=kubectx & alias kn=kubens"
if ! grep -q 'alias kx=kubectx'  ~/.bashrc; then
  echo 'alias kx=kubectx' >> ~/.bashrc
fi

if ! grep -q 'alias kn=kubens'  ~/.bashrc; then
  echo 'alias kn=kubens' >> ~/.bashrc
fi


echo "Configure Kubectl aliases"
# Download file into user's homedir
wget https://rawgit.com/ahmetb/kubectl-alias/master/.kubectl_aliases -O ~/.kubectl_aliases 
# Make file executable
chmod +x .kubectl_aliases

if ! grep -q 'kubectl_aliases'  ~/.bashrc; then
	echo "[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases" >> ~/.bashrc
else
	echo 'some aliases are already exist in ~/.bashrc. Remove them from ~/.bashrc or add them manually.'
fi


echo "Install kubetail with shortname to tail logs of multiple pods + containers"
rm -rf kubetail
#sudo rm /usr/bin/kubetail

# Clone kubetail repo into user's homedir
git clone https://github.com/johanhaleby/kubetail.git kubetail

# Make sym-link to cloned repo from known PATH directory 
sudo ln -s ~/kubetail/kubetail /usr/bin/

if ! grep -q 'kubetail.bash'  ~/.bash_completion; then
	cat $HOME/kubetail/completion/kubetail.bash | sudo tee /etc/bash_completion.d/kubetail > /dev/null
fi
if ! grep -q 'alias kt=kubetail'  ~/.bashrc; then
  echo 'alias kt=kubetail' >> ~/.bashrc
fi

echo 'DONE'