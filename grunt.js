/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    coffee: {
      src: {
        files: {
          "build/backbone.sync.js": "backbone.sync.coffee"
        }
      },
      tests: {
        files: {
          "build/backbone.sync.tests.js": "backbone.sync.tests.coffee"
        }
      }
    },
    watch: {
      all: {
        files: "*.coffee",
        tasks: "coffee"
      }
    }
  });

  grunt.loadNpmTasks("grunt-contrib-coffee");

  grunt.registerTask("default", "coffee");
  grunt.registerTask("test", function() {
    grunt.tasks("coffee");
    require("child_process").spawn("node_modules/.bin/mrt", [], {stdio: "inherit"});
  });
  grunt.registerTask("autotest", "test watch:all");
};
