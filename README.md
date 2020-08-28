A dead simple git smart-http server using nginx as a frontend. No authentication, no SSL, push is free-for-all.

> _caveat emptor_ this is not intended for production use

Usage:

```
docker run --rm 
  -p 8080:80 \
-v /path/to/host/gitdir:/git \
-e "INIT_REPOS=myrepo1,myrepo2" #Comma-delimited list of repos to create at initialization \
bgulla/git-http-backend
```


