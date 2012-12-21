Package.describe({
  summary: "A minimalist client-side MVC framework"
});

Package.on_use(function (api, where) {
  // XXX Backbone requires either jquery or zepto
  //api.use(["jquery", "json"]);
  
  where = where || ['client', 'server'];
  api.use('backbone', where);
  api.add_files('build/backbone.sync.js', where);
});

Package.on_test(function (api) {
  api.use(['minimongo', 'backbone'], ['client', 'server']);
  api.use('tinytest');
  api.add_files('build/backbone.sync.tests.js', ['client', 'server']);
});
