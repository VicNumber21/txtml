exports.parse = function(graph, txt) {
  graph.addNode('A', {label: 'A'});
  graph.addNode('B', {label: 'B'});
  graph.addNode('C', {label: 'C'});

  graph.addEdge(null, 'A', 'B', {label: 'A <-> B'});
  graph.addEdge(null, 'A', 'C', {label: 'A <-> C'});
  graph.addEdge(null, 'B', 'C', {label: 'B <-> C'});
};
