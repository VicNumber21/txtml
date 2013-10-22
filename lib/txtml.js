var Graph = require('Graphlib').Graph;
var renderer = require('./renderer');
var parser = require('./parser');

var txtml = {};

txtml.graph = new Graph();

txtml.parse = function(txt) {
  parser.parse(txtml.graph, txt);
  return txtml;
};

txtml.render = function(view) {
  renderer.render(txtml.graph, view);
  return txtml;
};

exports.txtml = txtml;
