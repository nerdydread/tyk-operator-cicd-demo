# CICD Demo with Tyk Operator

![CICD with Tyk Operator](./img/cicd-tyk-operator.png)

The general question that is asked by our clients is "how do we automate the deployment of our CRDs once they are merged into a master branch etc". In this demo we will take advantage of Tyk Operator and Github actions to allow the developers on our team to collaborate and contribute to a source of truth.

My current setup consists of Tyk Operator deployed to a virtual space on the cloud connected to a Tyk Cloud deployment. Essentially what will happen is that when PR is merged into my master branch, it will trigger a GitHub action that will connect to my Tyk Operator and run `kubectl apply -f` commands to automatically deploy the new CRDs that have been merged.

### Resources
- [Tyk Operator](https://github.com/TykTechnologies/tyk-operator)
