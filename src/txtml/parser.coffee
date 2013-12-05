pegjs = require 'pegjs'

type = {}
type.is_a = 'is_a'
type.has_a = 'has_a'
type.owns_a = 'owns_a'
type.use_a = 'use_a'

grammar = "
  start =
    line+

  line = 
    newline* st:statement newline? { return st; }

  statement =
    generalization /
    aggregation /
    composition /
    dependency

  generalization =
    l:name '--<|' r:name { return {type:'is_a', left:l, right:r}; } /
    l:name '|>--' r:name { return {type:'is_a', left:r, right:l}; }

  aggregation =
    l:name '<>-->' r:name { return {type:'has_a', left:l, right:r}; } /
    l:name '<--<>' r:name { return {type:'has_a', left:r, right:l}; }

  composition =
    l:name '<|>-->' r:name { return {type:'owns_a', left:l, right:r}; } /
    l:name '<--<|>' r:name { return {type:'owns_a', left:r, right:l}; }

  dependency =
    l:name '- ->' r:name { return {type:'uses_a', left:l, right:r}; } /
    l:name '<- -' r:name { return {type:'uses_a', left:r, right:l}; }

  name =
    space letters:[A-Za-z0-9:_]+ space { return letters.join(''); }

  space = [ \\t]*

  newline = '\\r'? '\\n'
"

parser = pegjs.buildParser grammar, {trackLineAndColumn: true}

safeAddNode = (graph, node) ->
  graph.addNode node, {label: node} unless graph.hasNode node

safeAddEdge = (graph, id, node1, node2, info) ->
  graph.addEdge id, node1, node2, info unless graph.hasEdge id

exports.parse = (graph, txt) ->
  doc = parser.parse txt

  for {left, type, right} in doc
    safeAddNode graph, left
    safeAddNode graph, right
    edgeId = left + type + right
    safeAddEdge graph, edgeId, left, right, {label: type}
