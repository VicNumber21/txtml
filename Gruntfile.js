module.exports = function(grunt) {
  var pkg = grunt.file.readJSON('package.json');

  grunt.initConfig({
    pkg: pkg,
    moduleName: pkg.name,
    moduleJs: '<%= moduleName %>.js',

    browserify: {
      build: {
        files: {
          'build/<%= moduleJs %>': ['browser.js']
        }
      }
    },
    watch: {
      src: {
        files: ['browser.js','lib/**/*.js'],
        tasks: ['build'],
        options: {
          spawn: false
        }
      }
    },
    download: {
      somefile: {
        url: 'http://d3js.org/d3.v3.min.js',
        manifest: false,
        filename: 'deps'
      },
    },
  });

  // Plugins
  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-download');

  // Targets
  grunt.registerTask('default', ['build']);
  grunt.registerTask('build', ['_init','browserify', 'download']);
  grunt.registerTask('clean', function() {
    grunt.file.delete('build');
  });

  // Internal targets
  grunt.registerTask('_init', function() {
    grunt.file.mkdir('build');
    grunt.file.mkdir('deps');
  });
};
