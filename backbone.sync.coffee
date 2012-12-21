Backbone.miniMongoSync = (method, model, options, error) ->
  coll = model.mCollection || model.collection.mCollection

  syncDfd = $? and $.Deferred and $.Deferred() #If $ is having Deferred - use it.

  callback = (error, ret=true) ->
    if error
      options.error error
      #model.trigger "error", model, null, options
      syncDfd.resolve() if syncDfd
    else
      options.success ret
      #model.trigger "sync", model, null, options
      syncDfd.reject() if syncDfd

  try
    switch method
      when "create"
        coll.insert model.attributes, (error, id) ->
          callback error, {id: id}
      when "update"
        # coll.find({_id: model.id}).observe
        #   changed: (doc) ->
        #     callback()
        delete model.attributes.id
        coll.update {_id: model.id}, {$set: model.attributes}
        callback()
      when "read"
        if model.attributes
          ret = coll.findOne(model.attributes)
        else
          ret = coll.find().fetch()

        error = null#if ret? not instanceof Array or ret.length > 0 then null else "Record not found"
        callback error, ret
      when "delete"
        coll.remove {id: model.id}, callback

  catch error
    options.error error
    syncDfd.reject() if syncDfd

  syncDfd && syncDfd.promise()

Backbone.ajaxSync = Backbone.sync

#Decide which sync method to use
Backbone.getSyncMethod = (model) ->
  if Meteor.is_server or model.mCollection or model.collection?.mCollection
    Backbone.miniMongoSync
  else
    Backbone.ajaxSync

# Override 'Backbone.sync' to detect if it is a minimongo model/collection or not
# and use the appropiate sync method
Backbone.sync = (method, model, options, error) ->
  Backbone.getSyncMethod(model)(method, model, options, error)