var renderer = require('./renderer');

var txtml = {};

txtml.render = function(view) {
  renderer.render(view);
  return txtml;
};

exports.txtml = txtml;
