var pegjs = require('pegjs');

var type = {};
type.is_a = 'is_a';
type.has_a = 'has_a';
type.owns_a = 'owns_a';
type.use_a = 'use_a';

var grammar =
  " start = " +
  "   line+ " +

  " line = " +
  "   st:statement newline? { return st; }" +

  " statement = " +
  "   generalization / " +
  "   aggregation / " +
  "   composition / " +
  "   dependency " +

  " generalization = " +
  "   l:name '<--<|' r:name { return {type:'is_a', left:l, right:r}; } / " +
  "   l:name '|>-->' r:name { return {type:'is_a', left:r, right:l}; } " +

  " aggregation = " +
  "   l:name '<>-->' r:name { return {type:'has_a', left:l, right:r}; } / " +
  "   l:name '<--<>' r:name { return {type:'has_a', left:r, right:l}; } " +

  " composition = " +
  "   l:name '<|>-->' r:name { return {type:'owns_a', left:l, right:r}; } / " +
  "   l:name '<--<|>' r:name { return {type:'owns_a', left:r, right:l}; } " +

  " dependency = " +
  "   l:name '- ->' r:name { return {type:'use_a', left:l, right:r}; } / " +
  "   l:name '<- -' r:name { return {type:'use_a', left:r, right:l}; } " +

  " name = " +
  "   space letters:[A-Za-z0-9:_]+ space { return letters.join(''); }" +

  " space = [ \\t]* " +

  " newline = '\\r'? '\\n' ";

var parser = pegjs.buildParser(grammar, {trackLineAndColumn: true});

function safe_add_node(graph, node) {
  if (!graph.hasNode(node)) {
    graph.addNode(node, {label: node});
  }
}

function safe_add_edge(graph, id, node1, node2, info) {
  if (!graph.hasEdge(id)) {
    graph.addEdge(id, node1, node2, info);
  }
}

exports.parse = function(graph, txt) {
  var doc = parser.parse(txt);

  for(i = 0; i < doc.length; ++i) {
    x = doc[i];
    safe_add_node(graph, x.left);
    safe_add_node(graph, x.right);
    safe_add_edge(graph, x.left + x.type + x.right, x.left, x.right, {label: x.type});
  }
};
