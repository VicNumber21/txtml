module.exports = function(grunt) {
  var pkg = grunt.file.readJSON('package.json');
  var version = pkg.version;
  var current_tags = [];
  var latest_tag = null;
  var toTag = function (version) {
    return 'v' + version;
  };
  var toVersion = function (tag) {
    return tag.match(/\d+\.\d+\.\d+/)[0];
  };
  var toSemver = function (version){
    return version.split('.');
  };
  var toString = function (semver) {
    return semver.join('.');
  };
  var compareSemver = function (lsemver, rsemver) {
    var res = 0;

    for(var i = 0; (res === 0) && (i < 3); ++i) {
      res = parseInt(lsemver[i], 10) - parseInt(rsemver[i], 10);
    }

    return res;
  };
  var feature_branch = null;
  var spawn = grunt.util.spawn;
  var contains = function(arr, elem) {
    return (arr.indexOf(elem) != -1);
  };
  var git = function (done, args, handler, supress_error) {
    spawn({cmd: 'git', 'args': args}, function(error, result, code) {
      if (code !== 0) {
        if (supress_error) {
          console.log('suppressed git error:\n' + error);
        } else {
          grunt.warn(error, code);
        }
      } else {
        console.log('git output:\n' + result.stdout);
      }

      if (handler) {
        handler(result.stdout);
      }

      done();
    });
  };
  var publish_repo = 'origin'

  grunt.initConfig({
    pkg: pkg,
    moduleName: pkg.name,
    moduleJs: '<%= moduleName %>.js',
    moduleMinJs: '<%= moduleName %>.min.js',
    moduleUnitJs: '<%= moduleName %>.unit.js',

    coffee: {
      options: {
        bare: true,
        sourceMap: true
      },
      compile: {
        files: [{
          expand: true,
          cwd: 'src/',
          src: ['**/*.coffee'],
          dest: 'lib/node_modules/',
          ext: ".js"
        }]
      },
      unit: {
        files: [{
          expand: true,
          cwd: 'test/auto/',
          src: ['**/*.coffee'],
          dest: 'lib/',
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
          'build/<%= moduleJs %>': ['lib/txtml-bundle.js']
        }
      },
      unit: {
        files: {
          'build/<%= moduleUnitJs %>': ['lib/unit-bundle.js']
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
        files: ['Gruntfile.js','lib/**/*.js', 'src/**/*.coffee', 'test/**/*.coffee'],
        tasks: ['build', 'unit'],
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
  grunt.registerTask('merge', ['_feature_branch', '_current_tags', '_latest_tag', '_manage_version']);

  grunt.registerTask('clean', function() {
    grunt.file.delete('lib/node_modules');
    grunt.file.delete('lib/unit');
    grunt.file.delete('build');
  });

  // Internal targets
  grunt.registerTask('_init', function() {
    grunt.file.mkdir('build');
  });

  grunt.registerTask('_dump_version', function() {
    grunt.file.write('lib/node_modules/txtml/version.js', 'module.exports = "' + version + '"\n');
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

  grunt.registerTask('_latest_tag', function() {
    latest_tag = null;

    git(this.async(), ['describe', '--abbrev=0', '--tags'], function (result) {
        latest_tag = result.split('\n')[0];
    });
  });

  grunt.registerTask('_manage_version', function() {
    if (feature_branch && !contains(current_tags, toTag(version))) {
      if (compareSemver(toSemver(version), toSemver(toVersion(latest_tag))) > 0) {
        grunt.task.run('_merge_new_version');
      } else {
        grunt.task.run('_create_new_version');
      }
    }
  });

  grunt.registerTask('_create_new_version', ['_check_uncommitted_changes',
                                             '_next_version',
                                             '_save_version',
                                             '_commit_version',
                                             '_merge_new_version']);

  grunt.registerTask('_merge_new_version', ['_merge_version',
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

  grunt.registerTask('_merge_version', ['_checkout_develop', '_merge_feature_branch']);

  grunt.registerTask('_checkout_develop', function() {
    git(this.async(), ['checkout', 'develop']);
  });

  grunt.registerTask('_merge_feature_branch', function() {
    git(this.async(), ['merge', '--commit', '--no-edit', '--no-ff', feature_branch]);
  });

  grunt.registerTask('_tag_version', function() {
    git(this.async(), ['tag', toTag(version)]);
  });

  grunt.registerTask('_push_version', ['_push_commit', '_push_tag', '_remove_feature_branch']);

  grunt.registerTask('_push_commit', function() {
    git(this.async(), ['push', '--prune', publish_repo, 'develop']);
  });

  grunt.registerTask('_push_tag', function() {
    git(this.async(), ['push', publish_repo, toTag(version)]);
  });

  grunt.registerTask('_remove_feature_branch', function() {
    git(this.async(), ['push', publish_repo, '--delete', feature_branch], null, true);
  });

  grunt.registerTask('_next_version', function() {
    var semver = toSemver(version);
    semver[2] = '' + (parseInt(semver[2], 10) + 1);
    version = toString(semver);
    console.log('Next version ' + version);
  });

  grunt.registerTask('_save_version', function() {
    console.log('Writing version ' + version + ' to package.json');
    pkg.version = version;
    grunt.file.write('package.json', JSON.stringify(pkg, undefined, 2) + '\n');
  });
};
