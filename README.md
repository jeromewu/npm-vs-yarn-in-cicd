# npm-vs-yarn-in-cicd
A (hopefully) comprehensive speed experiment for npm and yarn install in docker

## Preparation

Before starting the experiment, we need to update the permission of `registry-storage`.

```
$ sudo chown -R 10001:65533 registry-storage
```

More details [HERE](https://verdaccio.org/docs/en/docker.html#running-verdaccio-using-docker)
