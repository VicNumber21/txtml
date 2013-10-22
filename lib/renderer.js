var Renderer = require('dagre-d3').Renderer;

var r = new Renderer()

exports.render = function (graph, view) {
  r.run(graph, d3.select(view));
};
