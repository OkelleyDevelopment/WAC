# WAC - Workshop in A Container

## Motivation

Develop and implement a containerized workspace for streamlined development on projects. Help define
a baseline standard for all development to mitigate the risks of differing project dependencies.

## Prerequisites

- docker-ce

## Program Compilation and Execution

To build the image:

```
docker build . -t <tag name>
```

To run and connect:

```
docker container run -it <container tag name>
```

## Known Bugs / Issues

- Do not use in production as the login is the same for everyone unless modified locally.

## Future Goals

- [] Tailor with multi-stage builds, to allow for specific language development
- [] Add instructions for having a script that installs the dependencies for developers to reduce image size
