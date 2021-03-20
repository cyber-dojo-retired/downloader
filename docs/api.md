# API

- - - -
## GET download_kata(id)
Downloads a .tgz file of a git repository whose master branch
contains an individual cyber-dojo practice session (which might
have been part of a group). Each test submission is a tagged 
git commit.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
  The six-character id of an individual cyber-dojo practice session. 
- returns [(JSON-out)](#json-out)
- example
  ```bash
  $ curl \
    --data '{"id":"8Ey4xK"]}' \
    --header 'Content-type: application/json' \
    --silent \
    -X POST \
      http://${IP_ADDRESS}:${PORT}/download_kata

  {"download_kata":true}
  ```


- - - -
## GET download_group(id)
Downloads a .tgz file of a git repository whose branches 
correspond to the avatars in a cyber-dojo group practice session.
Each test submission is a tagged git commit.
- parameters [(JSON-in)](#json-in)
  * **id:String**.
  The six-character id of a group cyber-dojo practice session. 
- returns [(JSON-out)](#json-out)
- example
  ```bash
  $ curl \
    --data '{"id":"S78Ek1"]}' \
    --header 'Content-type: application/json' \
    --silent \
    -X POST \
      http://${IP_ADDRESS}:${PORT}/download_group

  {"download_group":true}
  ```


- - - -
## GET ready?
Tests if the service is ready to handle requests.
Used as a [Kubernetes](https://kubernetes.io/) readiness probe.
- parameters
  * none
- returns [(JSON-out)](#json-out)
  * **true** if the service is ready
  * **false** if the service is not ready
- example
  ```bash     
  $ curl --silent -X GET http://${IP_ADDRESS}:${PORT}/ready?

  {"ready?":false}
  ```

- - - -
## GET alive?
Tests if the service is alive.
Used as a [Kubernetes](https://kubernetes.io/) liveness probe.  
- parameters
  * none
- returns [(JSON-out)](#json-out)
  * **true**
- example
  ```bash     
  $ curl --silent -X GET http://${IP_ADDRESS}:${PORT}/alive?

  {"alive?":true}
  ```

- - - -
## GET sha
The git commit sha used to create the Docker image.
- parameters
  * none
- returns [(JSON-out)](#json-out)
  * the 40 character commit sha string.
- example
  ```bash     
  $ curl --silent -X GET http://${IP_ADDRESS}:${PORT}/sha

  {"sha":"41d7e6068ab75716e4c7b9262a3a44323b4d1448"}
  ```
  
- - - -
## JSON in
- All methods pass any arguments as a json hash in the http request body.
  * If there are no arguments you can use `''` (which is the default
    for `curl --data`) instead of `'{}'`.

- - - -
## JSON out      
- All methods return a json hash in the http response body.
  * If the method completes, a string key equals the method's name. eg
    ```bash
    $ curl --silent -X GET http://${IP_ADDRESS}:${PORT}/ready?

    {"ready?":true}
    ```
  * If the method raises an exception, a string key equals `"exception"`, with
    a json-hash as its value. eg
    ```bash
    $ curl --silent -X POST http://${IP_ADDRESS}:${PORT}/group_create_custom | jq      

    {
      "exception": {
        "path": "/download_group",
        "body": "",
        "class": "DownloaderService",
        "message": "...",
        "backtrace": [
          ...
          "/usr/bin/rackup:23:in `<main>'"
        ]
      }
    }
    ```
  
