Graph = require('graphlib').Digraph
renderer = require 'txtml/renderer'
parser = require 'txtml/parser'

txtml = {}

txtml.parse = (txt) ->
  txtml.graph = new Graph
  parser.parse txtml.graph, txt
  txtml

txtml.render = (view) ->
  renderer.render txtml.graph, view
  txtml

exports.txtml = txtml
