# Read through cache for accessing dropbox contents.

```coffeescript
dropbox = require 'dropbox-cache' # replaced require 'dropbox' with require 'dropbox-cache'

# Use dropbox as normal

client = new dropbox.Client {
  key: app.get 'dropbox key'
  secret: app.get 'dropbox secret'
  token: req.user.token
  tokenSecret: req.user.tokenSecret
  uid: req.user._json.uid
}

client.readdir '/', (error, files) ->
  for file in files
    console.log file
```

What is the problem?
--------------------

Performing a sub-request for ever piece of content loaded from Dropbox results in a show interface. Downloading and maintaining a complete replica is intensive and overkill for most uses. A method to easily cache requests to dropbox means a responsive UI.


How dropbox-cache solves this problem
-------------------------------------

1. A lightweight wrapping of the dropbox api to provide caching for three functions: readFile, readdir and stat
2. Caching based on time, manual clearing of the cache planned


Goals
-----

1. Identical api
2. Simple 'refresh button' cache clear


Todo
----

1. Refresh button cache clear