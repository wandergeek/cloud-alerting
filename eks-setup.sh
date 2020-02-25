#!/bin/bash

if [ -z "${PASSWORD}" ]; then
  echo 'Cluster $PASSWORD is required'
  exit 1
fi

if [ -z "${ENCRYPTION_KEY}" ]; then
  echo 'Cluster $ENCRYPTION_KEY is required'
  exit 1
fi

if [ -z "${SECURITY_KEY}" ]; then
  echo 'Cluster $SECURITY_KEY is required'
  exit 1
fi

if [ -z "${ELASTICSEARCH_HOST}" ]; then
  echo 'Cluster $ELASTICSEARCH_HOST is required'
  exit 1
fi


gcloud container clusters get-credentials aaas-eks-testing --zone us-central1-a --project elastic-cloud-dev

if [ -n "$INSTALL_ECK" ]; then
  kubectl apply -f https://download.elastic.co/downloads/eck/1.0.0/all-in-one.yaml
fi

kubectl create secret generic kibana-elasticsearch-credentials --from-literal=elasticsearch.password=$PASSWORD
kubectl create secret generic kibana-saved-objects-key --from-literal=xpack.encryptedSavedObjects.encryptionKey=$ENCRYPTION_KEY
kubectl create secret generic kibana-security-key --from-literal=xpack.security.encryptionKey=$SECURITY_KEY

cat <<EOF | kubectl apply -f -
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: cloud-alerting-staging
spec:
  version: 7.6.0
  image: gcr.io/elastic-cloud-dev/cloud-alerting:7.6.0
  count: 1
  config:
    elasticsearch.preserveHost: true
    elasticsearch.hosts:
      - $ELASTICSEARCH_HOST
    elasticsearch.username: elastic
    kibana.index: .kibana
    xpack.actions.enabled: true
    xpack.alerting.enabled: true
  secureSettings:
    - secretName: kibana-elasticsearch-credentials
    - secretName: kibana-saved-objects-key
    - secretName: kibana-security-key
EOF

cat << EOF kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: my-lb-service
spec:
  type: LoadBalancer
  selector:
    common.k8s.elastic.co/type: kibana
    kibana.k8s.elastic.co/name: cloud-alerting-staging
  ports:
  - protocol: TCP
    port: 5601
    targetPort: 5601
EOF
