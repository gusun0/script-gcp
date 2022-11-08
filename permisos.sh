PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER="$(gcloud projects describe ${PROJECT_ID} \
	--format='get(projectNumber)')"
cat >/tmp/kubernetes-cd-env-policy.yaml <<EOF
bindings:
 - members:
   - serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com
   role: roles.source.writer
EOF
gcloud source repos set-iam-policy \
	kubernetes-cd-env /tmp/kubernetes-cd-env-policy.yaml
