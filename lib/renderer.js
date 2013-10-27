var Renderer = require('dagre-d3').Renderer;

var r = new Renderer()

exports.render = function (graph, view) {
  var svg = d3.select(view);
  svg.selectAll('*').remove();
  r.run(graph, svg.append('g'));
};
