docker build -t dave123456789/multi-client-k8s:latest -t dave123456789/multi-client-k8s:$SHA -f ./client/Dockerfile ./client
docker build -t dave123456789/multi-server-k8s-pgfix:latest -t dave123456789/multi-server-k8s-pgfix:$SHA -f ./server/Dockerfile ./server
docker build -t dave123456789/multi-worker-k8s:latest -t dave123456789/multi-worker-k8s:$SHA -f ./worker/Dockerfile ./worker

# lastest is pushed because if someone runs kubectl apply -f k8s from build directory we want to insure they load current latest (this image)
docker push dave123456789/multi-client-k8s:latest
docker push dave123456789/multi-server-k8s-pgfix:latest
docker push dave123456789/multi-worker-k8s:latest

docker push dave123456789/multi-client-k8s:$SHA
docker push dave123456789/multi-server-k8s-pgfix:$SHA
docker push dave123456789/multi-worker-k8s:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=dave123456789/multi-server-k8s-pgfix:$SHA
kubectl set image deployments/client-deployment client=dave123456789/multi-client-k8s:$SHA
kubectl set image deployments/worker-deployment worker=dave123456789/multi-worker-k8s:$SHA
# note that no nginx needed because routing is done via ingress-service.yaml on k8s