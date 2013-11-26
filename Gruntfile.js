module.exports = function(grunt) {
  var pkg = grunt.file.readJSON('package.json');
  var version = pkg.version;

  grunt.initConfig({
    pkg: pkg,
    moduleName: pkg.name,
    moduleJs: '<%= moduleName %>.js',
    moduleMinJs: '<%= moduleName %>.min.js',
    moduleUnitJs: '<%= moduleName %>.unit.js',

    coffee: {
      options: {
        bare: true
      },
      compile: {
        files: [{
          expand: true,
          flatten: true,
          cwd: 'src/',
          src: ['**/*.coffee'],
          dest: 'lib/txtml/',
          ext: ".js"
        }]
      },
      unit: {
        files: [{
          expand: true,
          flatten: true,
          cwd: 'test/auto/unit/',
          src: ['**/*.coffee'],
          dest: 'lib/unit/',
          ext: ".js"
        }]
      }
    },
    concat: {
      unit: {
        src: ['lib/unit/*.js'],
        dest: 'build/unit.js'
      }
    },
    copy: {
      unit: {
        files: [
          {expand:true, src: 'test/auto/unit/unit.html', dest: 'build/', flatten: true},
          {expand:true, src: 'node_modules/chai/chai.js', dest: 'build/', flatten: true},
          {expand:true, src: 'node_modules/grunt-mocha/node_modules/mocha/mocha.js', dest: 'build/', flatten: true},
          {expand:true, src: 'node_modules/grunt-mocha/node_modules/mocha/mocha.css', dest: 'build/', flatten: true}
        ]
      }
    },
    browserify: {
      options: {
        aliasMappings: [
          {cwd: 'lib/', src: ['**/*.js']}
        ]
      },
      compile: {
        files: {
          'build/<%= moduleJs %>': ['browser.js']
        }
      },
      unit: {
        files: {
          'build/<%= moduleUnitJs %>': ['ut-browser.js']
        }
      }
    },
    uglify: {
      optimize: {
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
    },
    mocha: {
      options: {
        bail: true,
        log: true,
        reporter: 'Spec',
        run: true
      },
      all: [ 'build/unit.html' ]
    }
  });

  // Plugins
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-mocha');

  // Targets
  grunt.registerTask('default', ['build']);
  grunt.registerTask('build', ['compile', 'optimize']);
  grunt.registerTask('compile', ['_init', '_dump_version', 'coffee:compile', 'browserify:compile']);
  grunt.registerTask('optimize', ['uglify:optimize']);

  grunt.registerTask('unit', ['compile_unit', 'prepare_unit', 'mocha']);
  grunt.registerTask('compile_unit', ['_dump_version', 'coffee:compile', 'browserify:unit', 'coffee:unit', 'concat:unit']);
  grunt.registerTask('prepare_unit', ['copy:unit']);

  grunt.registerTask('clean', function() {
    grunt.file.delete('lib');
    grunt.file.delete('build');
  });

  // Internal targets
  grunt.registerTask('_init', function() {
    grunt.file.mkdir('build');
  });

  grunt.registerTask('_dump_version', function() {
    grunt.file.write('lib/txtml/version.js', 'exports.version = "' + version + '"\n');
  });
};
