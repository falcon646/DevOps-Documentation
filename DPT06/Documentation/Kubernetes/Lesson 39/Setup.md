aws eks update-kubeconfig --name <eks-name> --region <region>
aws eks update-kubeconfig --name dpt-eks-UQHKZXU3 --region us-east-1

### Aplication details
    
- nginx frontend pod
- nginx nodeport service listeining on port 80 which routes to login-app-service at 8080
- login-app pod
- loginapp service listeining on port 8080