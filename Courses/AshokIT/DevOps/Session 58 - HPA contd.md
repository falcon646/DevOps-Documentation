### HorizontalPodAutoscaler Walkthrough
- create deployment and service
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  selector:
    matchLabels:
      run: php-apache
  template:
    metadata:
      labels:
        run: php-apache
    spec:
      containers:
        - name: php-apache
          image: registry.k8s.io/hpa-example
          ports:
            - containerPort: 80
          resources:
            limits:
              cpu: 500m
            requests:
              cpu: 200m
---
apiVersion: v1
kind: Service
metadata:
  name: php-apache
  labels:
    run: php-apache
spec:
  ports:
    - port: 80
  selector:
    run: php-apache
```
- apply the workload `kubectl apply -f test-deploy.yml`
- create HPA over deployment `kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10`
- increase load on Service  (use ctrl+c to stop load) `kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"`
- Watch HAP Details `kubectl get hpa php-apache --watch`
- view generated HPA YAML file `kubectl get hpa php-apache -o yaml > /tmp/hpa-v2.yaml`

- In this example, the HPA named "php-apache" is configured to scale the pods in the deployment named "nginx-deployment". The HPA is set to maintain an average CPU utilization of 50%. The minimum number of replicas is set to 2, and the maximum number of replicas is set to 10.
```bash
# Create an HPA:
kubectl create -f hpa.yaml

# list HPAs:
kubectl get hpa

# explain the hpa
kubectl describe hpa <hpa-name>

Edit an HPA:
kubectl edit hpa <hpa-name>

# Delete an HPA:
kubectl delete hpa <hpa-name>
```
