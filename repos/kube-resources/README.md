# Kubernetes Resources

Ideally, this would be its own repository, and it would be versioned/tagged with every release. In this way, application-development teams can leverage it and reference newer versions when they are ready.
</br>
The following Kuberenetes resources are provisioned in the cluster:
* A `heal-app` namespace in which to provision all cluster resources
* A service account for the vault instance (associated with the Heal worker app)
* 3 deployments:
    * Heal Web Application
    * Heal Worker Applicatin
    * Redis Instance
* A service of type `ClusterIP` to expose the Redis deployment within the cluster
