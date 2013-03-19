dropbox = require 'dropbox'
tapinto = require 'tapinto'
cache = require 'memory-cache'
_ = require 'underscore'

# cache - by user
# invalidation: revision, expiry

class Client extends tapinto.Class(dropbox.Client)
  constructor: (@options) ->
    super
    
  readFile: (path, options, callback) ->
    file = cache.get "#{@dropboxUid()}:#{path}:file"
    
    if file?
      (callback or options) null, file.content, file.stat, file.range
      return false
    
    (error, content, stat, range) ->
      return if error?
        
      cache.put "#{@dropboxUid()}:#{path}:file", {
        content: content
        stat: stat
        range: range
      }
  
  readdir: (path, options, callback) ->
    dir = cache.get "#{@dropboxUid()}:#{path}:dir"
    
    if dir?
      (callback or options) null, dir.files, dir.dirstat, dir.filestats
      return false
    
    (error, files, dirstat, filestats) ->
      return if error?
        
      cache.put "#{@dropboxUid()}:#{path}:dir", {
        files: files
        dirstat: dirstat
        filestats: filestats
      }
  
  stat: (path, options, callback) ->
    stat = cache.get "#{@dropboxUid()}:#{path}:stat"
    if stat?
      (callback or options) null, stat.stat, stat.filestats
      return false
      
    (error, stat, filestats) ->
      return if error?
      
      cache.put "#{@dropboxUid()}:#{path}:stat", {
        stat: stat
        filestats: filestats
      }
      

module.exports = _.extend {}, dropbox, {
  Client: Client
}