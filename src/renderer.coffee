Renderer = require('dagre-d3').Renderer

r = new Renderer

exports.render = (graph, view) ->
  svg = d3.select view
  svg.selectAll('*').remove
  r.run graph, svg.append('g')
