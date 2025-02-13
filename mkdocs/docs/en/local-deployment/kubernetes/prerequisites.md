# Kubernetes Prerequisites

TODO

## Hardware Requirements

- **Operating System**: A Linux-based system or Windows Subsystem for Linux (WSL) for Windows users.
- **Memory**: A minimum of **8GB RAM** to manage multiple containerized services and Kubernetes workloads.
- **Processor**: At least a **2-core CPU** for handling orchestration tasks efficiently.
- **Architecture**: Support for **AMD64 architecture**.

## Software Requirements

- **Kubernetes**  
   Kubernetes is the backbone of container orchestration. Ensure that your Kubernetes cluster is set up and functioning properly. [Kubernetes Setup Guide](https://kubernetes.io/docs/setup/)

- **kubectx and kubens**
  kubectx is a tool to switch between contexts (clusters) on kubectl faster.
  kubens is a tool to switch between Kubernetes namespaces (and configure them for kubectl) easily.
  [kubectx and kubens Setup Guide](https://github.com/ahmetb/kubectx)

- **Helm**  
   Helm simplifies the deployment and management of Kubernetes applications. Ensure Helm is installed and configured. [Helm Installation Guide](https://helm.sh/docs/intro/install/)

- **HelmFile**  
   HelmFile allows you to define, sync, and manage Helm charts through declarative YAML files, enhancing the management of multi-chart deployments. [HelmFile Installation Guide](https://github.com/helmfile/helmfile?tab=readme-ov-file#installation)

- **yq** and **jq**  
   These command-line tools are essential for manipulating YAML and JSON files. They are necessary for handling configuration files in Kubernetes and Helm deployments. [yq Documentation](https://github.com/mikefarah/yq#install) | [jq Documentation](https://stedolan.github.io/jq/download/)

Once your system meets these hardware and software requirements, you will be ready to deploy and manage your applications using Kubernetes, Helm, HelmFile, and HelmSecrets!
