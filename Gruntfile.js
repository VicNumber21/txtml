module.exports = function(grunt) {
  var pkg = grunt.file.readJSON('package.json');

  grunt.initConfig({
    pkg: pkg,
    moduleName: pkg.name,
    moduleJs: '<%= moduleName %>.js',
    moduleMinJs: '<%= moduleName %>.min.js',

    coffee: {
      options: {
        bare: true
      },
      compile: {
        files: {
          'lib/renderer.js' : 'src/renderer.coffee',
          'lib/parser.js' : 'src/parser.coffee',
          'lib/txtml.js' : 'src/txtml.coffee'
        }
      }
    },
    browserify: {
      build: {
        files: {
          'build/<%= moduleJs %>': ['browser.js']
        }
      }
    },
    uglify: {
      build: {
        files: {
          'build/<%= moduleMinJs %>': ['build/<%= moduleJs %>']
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
    }
  });

  // Plugins
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // Targets
  grunt.registerTask('default', ['build']);
  grunt.registerTask('build', ['_init', 'coffee', 'browserify', 'uglify']);
  grunt.registerTask('clean', function() {
    grunt.file.delete('lib');
    grunt.file.delete('build');
  });

  // Internal targets
  grunt.registerTask('_init', function() {
    grunt.file.mkdir('build');
  });
};
