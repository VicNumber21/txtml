var Graph = require('Graphlib').Digraph;
var renderer = require('./renderer');
var parser = require('./parser');

var txtml = {};

txtml.parse = function(txt) {
  txtml.graph = new Graph();
  parser.parse(txtml.graph, txt);
  return txtml;
};

txtml.render = function(view) {
  renderer.render(txtml.graph, view);
  return txtml;
};

exports.txtml = txtml;
