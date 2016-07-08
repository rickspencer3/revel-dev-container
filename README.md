# Introduction
A development container is just what it sounds like, a container designed to facilitate make it easy for developers to write code with a specific framework. A well designed development container will remove any concern about installing the framework and tools, managing associated infrastructure such as databases, or pretty much anything that will distract the developer from actually writing code. Additionally, it will assume that the developer is creating micro-services and immutable infrastucture.

A good development container will work "out of the box." This entails creating and running a default project if necessary, or simply running a project if it is already present.

# Create a Repository
We are going to use Stacksmith to generate the base Dockerfile that we will use. This is important because Bitnami actively maintains their base images. If we use Stacksmith to generate the Dockerfile, Bitnami will automatically send us a pull request if their base image gets updated for any reason. In this way we stay up to date, and even automate it.

I created a repository called "revel-dev-container". Now it is a simple matter of filling in the form in Stacksmtih. Luckily, Bitnami has a base image all set up for Go development.

# Create the Dockerfile
##What Stacksmith Provides
You don't need to sign into Bitnami to use Stacksmith. But you do need to be logged in to use the Github integration. So, make sure you have an account and are signed in.

![The Stacksmith form is completed and using the repository and the Go base image](./sm1.png)

After clicking "Create stack" I can go to github repro and see that there is a pull request from Stacksmith. It is asking to add a Dockerfile, which is of course what I want. So I merge the pull request. And then pull it. Now I have a Dockerfile locally, that looks like this:

```
## BUILDING
##   (from project root directory)
##   $ docker build -t rickspencer3-revel-dev-container .
##
## RUNNING
##   $ docker run rickspencer3-revel-dev-container

FROM gcr.io/stacksmith-images/debian-buildpack:wheezy-r07

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="l51eq4k" \
    STACKSMITH_STACK_NAME="rickspencer3/revel-dev-container" \
    STACKSMITH_STACK_PRIVATE="1"

RUN bitnami-pkg install go-1.6.2-0 --checksum 79b828a23b7582197799e775d65501b082d71d589ba6eed7aa3d68cf75b94a19

ENV GOPATH=/gopath
ENV PATH=$GOPATH/bin:/opt/bitnami/go/bin:$PATH

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

# Go base template
COPY . /app
WORKDIR /app

```

The important line is this:

```
## STACKSMITH-END: Modifications below this line will be unchanged when regenerating
```

If we do all of our work in the container below that line, then Stacksmith can make a pull request by changing only what is above that line. This will allow me to automate testing and other cool things when Stacksmith has an update.

## Build the Container
Let's start out by building the container from the Dockerfile just to make sure it all works well. I like to tag the images when I build them to make them easier to run, so:

```
$ docker build -t revel .
```
Of course since it is unmodified, it builds perfectly fine. Let's take a look inside, though. Note that I am mounting a local directory called "app". The reason for this will be clear later. The fact that the container will be used in development of immutable infrastructure should be an early clue, though.

```
$ docker run -it -v /Users/rick/revel-dev-container/app:/app revel /bin/bash

        _____
 ______/_____\_______
/                    \
!    Bitnami         !
!      Stacksmith    !
\____________________/
         {\ }
         { \}
         L_ }
        / _)}
       / /__L
 _____/ (____)  Welcome to your rickspencer3/revel-dev-container container!
        (____)  Go to https://stacksmith.bitnami.com/dashboard/stacks/l51eq4k
 _____  (____)  to manage your stack.
      \_(____)  
         {\ }
         { \}
         \__/

root@65d461fd2182:/app#
```
I know the container will need use git to install revel, so let's make sure that git is installed.

```
root@2e980047b8de:/app# git --version
git version 1.7.10.4
```

## Add Revel to the container
This container will extend the default Go container by installing Revel. Instructions for installing Revel are available at the [Revel Github Page](https://revel.github.io/).

We do this using go get. Simply add this command to Dockerfile directly after the "STACKSMITH-END" part. Revel needs to build inside $GOPATH. Because we want the code to always be mounted externally (remember, the container is immutable) we can add the app directory to GOPATH in the container as well.

```
RUN go get github.com/revel/cmd/revel
ENV GOPATH=$GOPATH:/app
```

Now we can build and run the container again, and ensure that the revel commands work.

```
$ docker build -t revel .
$ docker run -it -v /Users/rick/revel-dev-container/app:/app revel /bin/bash
# revel new github.com/rickspencer3/bitnami-app
~
~ revel! http://revel.github.io
~
Your application is ready:
   /app/src/github.com/rickspencer3/bitnami-app

You can run it with:
   revel run github.com/rickspencer3/bitnami-app
   root@30e411634363:/app# revel run github.com/rickspencer3/bitnami-app
   ~
   ~ revel! http://revel.github.io
   ~
   INFO  2016/07/08 09:44:36 revel.go:365: Loaded module static
   INFO  2016/07/08 09:44:36 revel.go:365: Loaded module testrunner
   INFO  2016/07/08 09:44:36 revel.go:230: Initialized Revel v0.13.1 (2016-06-06) for >= go1.4
   INFO  2016/07/08 09:44:36 run.go:57: Running bitnami-app (github.com/rickspencer3/bitnami-app) in dev mode
   INFO  2016/07/08 09:44:36 harness.go:170: Listening on :9000

```
Since the container is immutable and I mounted the app directory from a local volume, we can see that the generated code was saved locally if I exit the container and look on my local directory.

```
# exit
exit
$ ls app/
src
```

# Override the Entry Point

# Create the docker-compose.yml file

#
