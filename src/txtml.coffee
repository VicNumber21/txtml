Graph = require('Graphlib').Digraph
renderer = require './renderer'
parser = require './parser'

txtml = {}

txtml.parse = (txt) ->
  txtml.graph = new Graph
  parser.parse txtml.graph, txt
  txtml

txtml.render = (view) ->
  renderer.render txtml.graph, view
  txtml

exports.txtml = txtml
