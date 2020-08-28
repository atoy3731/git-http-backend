# Git-HTTP-backend



A dead simple git smart-http server using nginx as a frontend. No authentication, no SSL, push is free-for-all.

> _disclaimer_ this is not intended for production use. Written to ease self-bootstrapping GitOps goodness.

![git-http-backend](static/thisisfine.png?raw=true)


## Usage:

Running the server: 
```bash
docker run --rm 
  -p 8080:80 \
  -v /path/to/host/gitdir:/git \
  -e "INIT_REPOS=myrepo1,myrepo2" \ #Comma-delimited list of repos to create at initialization 
  bgulla/git-http-backend
```

Cloning a repo
```bash
git clone http://localhost:8080/git/myrepo1.git
echo "profit!"
```

## Interactive Initialization
You will need to set the `INIT_REPOS` env var in order to self-bootstrap a repository within the /git folder. If you want to manually create the repo while the container is running, do the following:

```bash
cd /git
git init --bare test.git
cd test.git
git config http.receivepack true
```

