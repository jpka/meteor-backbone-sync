/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    // lint: {
    //   files: ['grunt.js', 'lib/**/*.js', 'test/**/*.js']
    // },
    // watch: {
    //   files: '<config:lint.files>',
    //   tasks: 'lint test'
    // },
    // jshint: {
    //   options: {
    //     curly: true,
    //     eqeqeq: true,
    //     immed: true,
    //     latedef: true,
    //     newcap: true,
    //     noarg: true,
    //     sub: true,
    //     undef: true,
    //     boss: true,
    //     eqnull: true
    //   },
    //   globals: {}
    // }
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
    require("child_process").spawn("mrt", [], {stdio: "inherit"});
  });
  grunt.registerTask("autotest", "test watch:all");
};
