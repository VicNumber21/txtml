Renderer = require('dagre-d3').Renderer

r = new Renderer

exports.render = (graph, view) ->
  svg = d3.select view
  svg.selectAll('*').remove()
  layout = r.run graph, svg.append('g')
  svg.attr "width", layout.graph().width
  svg.attr "height", layout.graph().height
