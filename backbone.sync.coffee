methodTable =
  read: "findOne"
  create: "insert"
  update: "update"
  delete: "destroy"

Backbone.miniMongoSync = (method, model, options, error) ->
  db = model.db || model.collection.db

  # Backwards compatibility with Backbone <= 0.3.3
  if typeof options == "function"
    options =
      success: options
      error: error

  syncDfd = $.Deferred && $.Deferred(); #If $ is having Deferred - use it.

  db[methodTable[method]] model.attributes, (error) ->
    if error
      options.error "Record not found"
      syncDfd.reject() if syncDfd
    else
      options.success model
      syncDfd.resolve() if syncDfd

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

# Override 'Backbone.sync' to detect if it is a minimongo model/collection or not
# and decide a sync method accordingly
Backbone.sync = (method, model, options, error) ->
  if model.db or (model.collection and model.collection.db)
    Backbone.miniMongoSync
  else
    Backbone.ajaxSync