# cloud-native-go-makefile

A generic makefile for cloud native go applications

## Introduction

This project assumes that all executables are located under the `cmd` directory.

## Usage

### Development

Build all executables
```bash
$ make all
```

Clean all executables
```bash
$ make clean
```

Run go test
```bash
$ make test
```

Run dep ensure
```bash
$ make dep
```

### Docker

Build docker image
```bash
$ make docker
```

Push docker image
```bash
$ make docker-push
```

> Note: Be sure to set `DOCKER_REPOSITORY` in `Makefile` for your own before building and pushing the docker image.

## License

The MIT License
