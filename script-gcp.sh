# habilita las API requeridas
gcloud services enable container.googleapis.com \
	cloudbuild.googleapis.com \
	sourcerepo.googleapis.com \
	containeranalysus,googleapis.com

# crea un cluster de GKE que usaras para implementar
# la aplicacion en este ejercicio
gcloud container clusters create hello-app-cd \
	--num-nodes 1 --zone us-central1-b

#si nunca usaste git en cloud shell
# configuralo con tu nombre y direccion de correo
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

#conecta la cuenta de usuario de gcp con glcoud source repositories
git config credential.helper gcloud.sh


# en cloud shell, crea los dos repositories de git
# el repositorio app contendra el codigo fuente
gcloud source repos create kubernetes-cd-app

# el repositorio env contentdra los manifestos
# para la implementacion de kubernetes
gcloud source repos create kubernetes-cd-env

# clona el codigo de ejemplo desde github
cd ~
git clone https://github.com/Juanmanuelramirez/hello-app-py.git \
	kubernetes-cd-app

# configura cloud source repositories como remoto
cd ~/kubernetes-cd-app
PROJECT_ID=$(gcloud config get-value project)
git remote add google \
	"https://source.developers.google.com/p/${PROJECT_ID}/r/kubernetes-cd-app"

# crea una compilacion de cloud build basada en la ultima confirmacion
cd ~/cd ~/kubernetes-cd-app
COMMIT_ID="$(git rev-parse --short-7 HEAD)"
gcloud builds submit --tag="gcr.io/${PROJECT_ID}/kubernetes-cd-cloudbuild:${COMMIT_ID}"
