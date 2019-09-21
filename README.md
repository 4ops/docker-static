# Kubernetes app static

Miminal container with [nginx](http://nginx.org), optimized for serving static content in kubernetes cluster.

## Building image with content

Build your own container with static files:

- See [example/Dockerfile](example/Dockerfile)

```shell
$ docker build . -t my.registry.com/path/to/image:v1.0.0
$ docker push my.registry.com/path/to/image:v1.0.0
```

## Deploying in kubernetes cluster

Customize template `github.com/4ops/static` with local `kustomization.yaml`:

- See [example/kustomization.yaml](example/kustomization.yaml)

Deploy your configuration:

```shell
$ kubectl apply -k .
```

Kustomize template for GitLab CI example:

```shell
$ cat <<EOF | kubectl apply -f -
namespace: ${CI_ENVIRONMENT_NAME}

namePrefix: ${CI_PROJECT_NAME}-
nameSuffix: -content

commonLabels:
  component: landing
  project: ${CI_PROJECT_NAME}

bases:
  - github.com/4ops/static
  - github.com/4ops/static/add/pdb

images:
  - name: 4ops/static
    newName: ${CI_REGISTRY_IMAGE}
    newTag: ${CI_PIPELINE_ID}

```
