### DevOps CI/CD Tools

*   **CI Servers:**
    *   **Jenkins:** An open-source automation server. Highly flexible with a massive plugin ecosystem.
    *   **GitLab CI/CD:** Tightly integrated into the GitLab platform. Configuration is done via a `.gitlab-ci.yml` file in the repo.
    *   **GitHub Actions:** Integrated directly into GitHub. Workflows are defined in `.yml` files within the `.github/workflows` directory.
    *   **CircleCI:** A cloud-based CI/CD service known for its simplicity and speed.

*   **Configuration Management & Deployment:**
    *   **Ansible:** An imperative, push-based automation tool for configuring systems and deploying applications.
    *   **Terraform:** A declarative tool for building, changing, and versioning infrastructure safely and efficiently. (Often used in a GitOps style but with a push-based workflow).

### GitOps CD Tools

*   **FluxCD:** A CNCF-incubated GitOps operator for Kubernetes. It ensures the cluster's state matches the config in git and automates deployments.
*   **ArgoCD:** A CNCF-incubated declarative GitOps continuous delivery tool for Kubernetes. It features a powerful web UI and is designed to be easy to understand.
*   **Jenkins X:** A CI/CD solution for cloud-native applications on Kubernetes that provides automation for GitOps promotion.

---

## Basic Commands and Installation

This section provides a quick start for some of the key tools mentioned.

### 1. Installing and Using a DevOps CI/CD Tool: GitHub Actions

GitHub Actions is built into GitHub.com and GitHub Enterprise Server. No installation is required for the server itself. You simply create workflow files.

**Basic Example: A Simple CI Pipeline (.github/workflows/ci.yml)**

```yaml
name: Simple CI Pipeline

on: [push] # Trigger on push to any branch

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout the code
      - name: Checkout code
        uses: actions/checkout@v4

      # Step 2: Set up a specific Java version
      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'

      # Step 3: Run a build and test command (e.g., using Maven)
      - name: Build and Test with Maven
        run: mvn clean test
```

**How to use:**
1.  Create a new directory in your repo: `.github/workflows/`
2.  Create a file named `ci.yml` inside it with the content above.
3.  Push the code. The workflow will run automatically.

### 2. Installing a GitOps CD Tool: FluxCD

FluxCD is installed on your Kubernetes cluster.

**Installation via CLI (using Homebrew on macOS/Linux)**

First, install the Flux CLI, which helps with bootstrapping.

```bash
# Install the Flux CLI
brew install fluxcd/tap/flux

# Prerequisite: Have a Kubernetes cluster running and your kubeconfig configured.
kubectl cluster-info

# Bootstrap Flux onto your cluster, pointing it to your Git repository.
# Replace the placeholders with your GitHub user and repo name.
flux bootstrap github \
  --owner=<your-github-username> \
  --repository=<your-repository-name> \
  --branch=main \
  --path=./clusters/my-cluster \ # Path inside the repo where configs are
  --personal
```
This command installs the Flux components in your cluster and sets up a deployment key so Flux can pull from your private repository.

**Basic Flux Command: Check Status**

```bash
# Get the status of Flux components and synchronized resources
flux get all
```

### 3. Installing a GitOps CD Tool: ArgoCD

ArgoCD is also installed on your Kubernetes cluster.

**Installation via kubectl**

```bash
# 1. Create the namespace
kubectl create namespace argocd

# 2. Install ArgoCD from the official manifest
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. (Optional) Install the ArgoCD CLI
# On macOS:
brew install argocd

# On Linux:
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

# 4. Get the initial admin password to login to the UI/CLI
# The ArgoCD API server is not exposed by default. You can use port-forwarding.
kubectl port-forward svc/argocd-server -n argocd 8080:443
# The password for the 'admin' user is auto-generated and stored in a secret.
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
# Open browser to https://localhost:8080 and login with user 'admin' and the password.

# 5. Add your Git repository to ArgoCD (via CLI after logging in)
argocd login localhost:8080
argocd repo add https://github.com/your-username/your-repo.git
```

**Basic ArgoCD Command: Create an Application**

```bash
# This tells ArgoCD to monitor a Git repo and sync an app
argocd app create my-app \
  --repo https://github.com/your-username/your-repo.git \
  --path ./k8s-manifests \ # Path to YAML files inside the repo
  --dest-server https://kubernetes.default.svc \ # Target cluster
  --dest-namespace default
```

---

## Conclusion

The choice between DevOps CI/CD and GitOps isn't necessarily binary. **GitOps is an evolution of DevOps practices**, specifically for the deployment and operations phase, often used in Kubernetes environments.

*   Use **DevOps CI/CD** practices for building, testing, and packaging your application artifacts. This is your **Continuous Integration** process.
*   Use **GitOps CD** practices to manage and automate the deployment and state of your application and infrastructure across environments. This is your **Continuous Deployment/Delivery** process.

Many modern teams successfully combine both: a push-based CI pipeline (e.g., GitHub Actions) handles the build and testing, and then commits updated manifests to a Git repo. A pull-based GitOps operator (e.g., ArgoCD) then automatically detects this change and deploys it to the appropriate clusters, providing a robust, secure, and auditable deployment workflow.
