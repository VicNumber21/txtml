var Graph = require('Graphlib').Graph;
var Renderer = require('dagre-d3').Renderer;

var g = new Graph();

g.addNode('A', {label: 'A'});
g.addNode('B', {label: 'B'});
g.addNode('C', {label: 'C'});

g.addEdge(null, 'A', 'B', {label: 'A <-> B'});
g.addEdge(null, 'A', 'C', {label: 'A <-> C'});
g.addEdge(null, 'B', 'C', {label: 'B <-> C'});

var r = new Renderer()

exports.render = function (view) {
  r.run(g, d3.select(view));
};
