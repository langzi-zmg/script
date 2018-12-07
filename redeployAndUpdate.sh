#!/bin/bash

# Parameters
# 需完整输入待操作的deployment名字,否则会出错
OLD_DEPLOYMENT_NAME=ivankafinfo
SERVICE_NAME=ivankafinfo
NAMESPACE=ivanka
REPLICA=1
IMAGE_NAME=finfo
IMAGE_VERSION=istio-sit
CONFIG_ETCDS=http://10.0.2.148:2379
CONFIGOR_ENV=ivktest

# 一般情况下不用动的变量
SERVICE_PORT=10088
REQUEST_CPU=1000m
REQUEST_MEM=1Gi
READY_SECONDS=60
TIMESTAMP=`date +%s`


if [ ! -n "$OLD_DEPLOYMENT_NAME" \
-o ! -n "$SERVICE_NAME" \
-o ! -n "$IMAGE_VERSION" \
-o ! -n "$NAMESPACE" \
-o ! -n "$REPLICA"  \
-o ! -n "$CONFIG_ETCDS" \
-o ! -n "$CONFIGOR_ENV" \
-o "$REPLICA" -eq 0 ];then
    echo "Parameters cannot be null"
    exit
fi

# 确保指定namespace存在
kubectl get namespace $NAMESPACE
if [ $? -ne 0 ];
then
    echo "Namespace $NAMESPACE is nonexistent"
    exit;
fi

# 确保老deployment存在
kubectl get deployment $OLD_DEPLOYMENT_NAME -n $NAMESPACE
if [ $? -ne 0 ];
then
    echo "Deployment $OLD_DEPLOYMENT_NAME is nonexistent"
    exit;
fi

# 确保指定service存在
kubectl get service $SERVICE_NAME -n $NAMESPACE
if [ $? -ne 0 ];
then
    echo "Service $SERVICE_NAME is nonexistent"
    exit;
fi

# Detect if old virtual service exists
kubectl get virtualservice $SERVICE_NAME -n $NAMESPACE

if [ $? -eq 0 ];
then
  echo 'Virtual service already exist!!!';
  echo 'We should verify virtual service first!!!';
  exit;
fi

kubectl get destinationrule $SERVICE_NAME -n $NAMESPACE

if [ $? -eq 0 ];
then
  echo 'Destination rule already exist!!!';
  echo 'We should verify destination rule first!!!';
  exit;
fi

# Create kubernetes deployment
echo "Start to create kubernetes deployment with version $IMAGE_VERSION";
cat << EOF | kubectl create -f -
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  annotations:
    description: $SERVICE_NAME
  labels:
    app: $SERVICE_NAME
    qcloud-app: $SERVICE_NAME
  name: $SERVICE_NAME-$IMAGE_VERSION-$TIMESTAMP
  namespace: $NAMESPACE
spec:
  minReadySeconds: 10
  progressDeadlineSeconds: 600
  replicas: $REPLICA
  revisionHistoryLimit: 5
  selector:
    matchLabels:
      app: $SERVICE_NAME
      version: $IMAGE_VERSION-$TIMESTAMP
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: $SERVICE_NAME
        qcloud-app: $SERVICE_NAME
        version: $IMAGE_VERSION-$TIMESTAMP
    spec:
      containers:
      - env:
        - name: PATH
          value: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        - name: CONFIGOR_ENV
          value: $CONFIGOR_ENV
        - name: CONFIG_ETCDS
          value: $CONFIG_ETCDS
        - name: CLOUD_PROVIDER
          value: istio
        image: ccr.ccs.tencentyun.com/dhub.wallstcn.com/$IMAGE_NAME:istio-$IMAGE_VERSION
        imagePullPolicy: Always
        name: $SERVICE_NAME
        ports:
        - containerPort: 10088
        resources:
          limits:
            cpu: "3"
            memory: 2Gi
          requests:
            cpu: $REQUEST_CPU
            memory: $REQUEST_MEM
        securityContext:
          privileged: false
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /opt/log
          name: log
      dnsPolicy: ClusterFirst
      imagePullSecrets:
      - name: hub-k358vimh
      - name: qcloudregistrykey
      - name: tencenthubkey
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
      volumes:
      - hostPath:
          path: /opt/log
        name: log
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: $SERVICE_NAME
  namespace: $NAMESPACE
spec:
  host: $SERVICE_NAME
  subsets:
  - name: v1
    labels:
      version: $IMAGE_VERSION-$TIMESTAMP
EOF

echo "Sleep $READY_SECONDS seconds for deployment ready...";
sleep $READY_SECONDS;

# Switch to the new service
cat << EOF | kubectl create -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: $SERVICE_NAME
  namespace: $NAMESPACE
spec:
  hosts:
    - $SERVICE_NAME
  http:
    - route:
        - destination:
            host: $SERVICE_NAME.$NAMESPACE.svc.cluster.local
            subset: v1
EOF

echo "Sleep $READY_SECONDS seconds for virtual service taking effect...";
sleep $READY_SECONDS;

echo 'Close old deployment';
# Close old deployment
kubectl delete deployment $OLD_DEPLOYMENT_NAME -n $NAMESPACE

# CleanUp My friend!!!
kubectl delete virtualservice $SERVICE_NAME -n $NAMESPACE
kubectl delete destinationrule $SERVICE_NAME -n $NAMESPACE
