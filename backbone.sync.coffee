methodTable =
  read: "findOne"
  create: "insert"
  update: "update"
  delete: "destroy"

Backbone.miniMongoSync = (method, model, options, error) ->
  coll = model.mCollection || model.collection.mCollection

  # Backwards compatibility with Backbone <= 0.3.3
  if typeof options is "function"
    options =
      success: options
      error: error

  # if typeof coll is "string"
  #   coll = new Meteor.Collection(coll)
  #   if model.mCollection
  #     model.mCollection = coll
  #   else
  #     model.collection.mCollection = coll

  syncDfd = $? and $.Deferred and $.Deferred() #If $ is having Deferred - use it.

  #if Meteor.is_client
  try
    coll[methodTable[method]] model.attributes, (error, id) ->
      if error
        options.error model, "Record not found"
        #model.trigger "error", model, null, options
        syncDfd.reject() if syncDfd
      else
        options.success
          id: id
        #model.trigger "sync", model, null, options
        syncDfd.resolve() if syncDfd
  catch error
    options.error error

  # else if Meteor.is_server
  #   id = coll[methodTable[method]] model.attributes
  #   options.success
  #     id: id

  # switch method
  #   when "read":
  #     dbDo "findOne", model
  #   when "create":
  #     dbDo "insert", model
  #   when "update":
  #     dbDo "update", model
  #     db.update model, cb
  #   when "delete":

  #     db.destroy model, cb

  syncDfd && syncDfd.promise()

Backbone.ajaxSync = Backbone.sync

#Decide which sync method to use
Backbone.getSyncMethod = (model) ->
  if Meteor.is_server or model.mCollection or (model.collection and model.collection.mCollection)
    Backbone.miniMongoSync
  else
    Backbone.ajaxSync

# Override 'Backbone.sync' to detect if it is a minimongo model/collection or not
# and use the appropiate sync method
Backbone.sync = (method, model, options, error) ->
  Backbone.getSyncMethod(model)(method, model, options, error)