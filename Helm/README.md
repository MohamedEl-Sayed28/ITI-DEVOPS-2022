# Helm Lab1
## Simple helm constructions for a Bakehouse website

## 1. Create a helm chart for the app below and deploy it (try to keep everything changeable using values.yaml)
https://github.com/SamarGooda/bakehouse-ITI.


### Minikube tunnel ( so can i access it from the browser )
![image](https://user-images.githubusercontent.com/101838529/217409826-15ee3e15-b339-488d-9198-62537f6d5e73.png)
### The app on browser
![image](https://user-images.githubusercontent.com/101838529/217409953-e337f5e0-c15e-4bda-a1b4-79dc5b49ba39.png)
### Helm upgrade & list
![image](https://user-images.githubusercontent.com/101838529/217410552-33177d24-53df-4175-9b5e-a7f7ad921444.png)

### Kubernetes
![image](https://user-images.githubusercontent.com/101838529/217411039-2773682a-f9fa-421e-9533-7ebfeba525b4.png)
![image](https://user-images.githubusercontent.com/101838529/217411081-348ab916-a309-4c96-92c5-24affc7d2ee8.png)


## 2. Deploy Jenkins Chart on the cluster and login to Jenkins. 

- Jenkins package https://artifacthub.io/packages/helm/jenkinsci/jenkins
- helm repo add jenkins https://charts.jenkins.io
- helm repo update

![image](https://user-images.githubusercontent.com/101838529/217414526-42f2ae90-07c8-44b3-832d-770081ebf8b2.png)

```
NOTES:
1. Get your 'admin' user password by running:
  kubectl exec --namespace default -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
2. Get the Jenkins URL to visit by running these commands in the same shell:
  echo http://127.0.0.1:8080
  kubectl --namespace default port-forward svc/jenkins 8080:8080

3. Login with the password from step 1 and the username: admin
4. Configure security realm and authorization strategy
5. Use Jenkins Configuration as Code by specifying configScripts in your values.yaml file, see documentation: http://127.0.0.1:8080/configuration-as-code and examples: https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos
```

![image](https://user-images.githubusercontent.com/101838529/217415358-031d1e84-7115-44be-a337-20d157e565c2.png)

![image](https://user-images.githubusercontent.com/101838529/217415622-d59ac6a9-8ceb-4a99-86b5-a80273caa5f1.png)
