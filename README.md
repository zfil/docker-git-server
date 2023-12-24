# docker-git-server

Small Git server Docker image to run for instance at home for your local lab.
Very low in resource usage, based on Alpine Linux and should be resonably secure.

Nothing very original, but I couldn't find something that satisfies me in the existing projects. Hopefully it could be useful for someone else.

All you data are in a docker volume /git-server I recommend to bind mount it.

## Usage

### Run the container

	docker run --name git-server -p 2222:22 -v ~/git-server-data:/git-server -d zfil/docker-git-server

### Authentication

Copy all the public keys you want to use in ~/git-server-data/client-keys/
When you add or remove keys you don't need to restart the container it is taken in real time.

### How to create a new repo

For instance this is will create a new repository called test-repo

	ssh -p 2222 git@yourserver git-init test-repo

### How to clone a repository

Provided your repository is called test-repo

	git clone ssh://git@yourserver:2222/git-server/repos/test-repo.git

### Build

You can use buildx to create multiplatform builds. Example for raspberry 3 and amd64:

	docker buildx create --name multi --platform linux/amd64,linux/arm/v7
	docker buildx build --builder multi --platform linux/amd64,linux/arm/v7 -t zfil/docker-git-server --push .
	docker buildx rm multi
