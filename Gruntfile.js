module.exports = function(grunt) {
  var pkg = grunt.file.readJSON('package.json');
  var version = pkg.version;
  var current_tags = [];
  var tag = function (version) {
    return 'v' + version;
  };
  var feature_branch = null;
  var spawn = grunt.util.spawn;
  var contains = function(arr, elem) {
    return (arr.indexOf(elem) != -1);
  };
  var git = function (done, args, handler) {
    spawn({cmd: 'git', 'args': args}, function(error, result, code) {
      if (code !== 0) {
        grunt.warn(error, code);
      } else {
        console.log('git output:\n' + result.stdout);
      }

      if (handler) {
        handler(result.stdout);
      }

      done();
    });
  };

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
  grunt.registerTask('publish', ['build', 'unit', 'merge']);
  grunt.registerTask('merge', ['_feature_branch', '_current_tags', '_manage_version']);

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

  grunt.registerTask('_manage_version', function() {
    if (feature_branch && !contains(current_tags, tag(version))) {
      grunt.task.run('_create_new_version');
    }
  });

  grunt.registerTask('_create_new_version', ['_check_uncommitted_changes',
                                             '_next_version',
                                             '_save_version',
                                             '_commit_version',
                                             '_merge_version',
                                             '_tag_version',
                                             '_push_version']);

  grunt.registerTask('_check_uncommitted_changes', ['_check_staged', '_check_unstaged']);

  grunt.registerTask('_check_staged', function() {
    git(this.async(), ['diff', '--shortstat', '--cached'], function (result) {
      if (result.length > 0) {
        grunt.warn('Cannot publish since stage area is not empty');
      }
    });
  });

  grunt.registerTask('_check_unstaged', function() {
    git(this.async(), ['diff', '--shortstat'], function (result) {
      if (result.length > 0) {
        grunt.warn('Cannot publish since there are uncommitted modifications');
      }
    });
  });

  grunt.registerTask('_commit_version', ['_stage_version', '_create_commit']);

  grunt.registerTask('_stage_version', function() {
    git(this.async(), ['add', 'package.json']);
  });

  grunt.registerTask('_create_commit', function() {
    git(this.async(), ['commit', '-m', 'Increase version to ' + version]);
  });

  grunt.registerTask('_merge_version', ['_checkout_develop',
                                        '_merge_feature_branch',
                                        '_remove_feature_branch']);

  grunt.registerTask('_checkout_develop', function() {
    git(this.async(), ['checkout', 'develop']);
  });

  grunt.registerTask('_merge_feature_branch', function() {
    git(this.async(), ['merge', '--commit', '--no-edit', '--no-ff', feature_branch]);
  });

  grunt.registerTask('_remove_feature_branch', function() {
    git(this.async(), ['branch', '-D', feature_branch]);
  });

  grunt.registerTask('_tag_version', function() {
    git(this.async(), ['tag', tag(version)]);
  });

  grunt.registerTask('_push_version', ['_push_commit', '_push_tag']);

  grunt.registerTask('_push_commit', function() {
    git(this.async(), ['push', '--prune', 'publish', 'develop']);
  });

  grunt.registerTask('_push_tag', function() {
    git(this.async(), ['push', 'publish', tag(version)]);
  });

  grunt.registerTask('_next_version', function() {
    var semver_txt = version.split('.');
    semver_txt[2] = '' + (parseInt(semver_txt[2], 10) + 1);
    version = semver_txt.join('.');
    console.log('Next version ' + version);
  });

  grunt.registerTask('_save_version', function() {
    console.log('Writing version ' + version + ' to package.json');
    pkg.version = version;
    grunt.file.write('package.json', JSON.stringify(pkg, undefined, 2) + '\n');
  });

  grunt.registerTask('_feature_branch', function() {
    feature_branch = null;

    git(this.async(), ['branch', '--contains'], function (result) {
      var branches = result.split('\n');

      for (var i = 0; i < branches.length; ++i) {
        var feature_branch_match = branches[i].match(/feature\/\S+/);

        if (feature_branch_match) {
          feature_branch = feature_branch_match[0];
          break;
        }
      }
    });
  });

  grunt.registerTask('_current_tags', function() {
    current_tags = [];

    git(this.async(), ['tag', '--contains'], function (result) {
        current_tags = result.split('\n');
    });
  });
};
