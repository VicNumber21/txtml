expectEtalonGaph = (g, nodeSpec, edgeSpec) ->
      expect(g.order()).to.be.equal nodeSpec.length
      expect(g.hasNode node).to.be.true for node in nodeSpec

      expect(g.size()).to.be.equal edgeSpec.length

      for [left, type, right] in edgeSpec
        edgeId = left + type + right
        expect(g.hasEdge edgeId).to.be.true
        expect(g.incidentNodes edgeId).to.have.members [left, right]
        expect(g.edge edgeId).to.be.deep.equal {label: type}

describe 'Parser tests', ->
  Graph g = null

  describe 'Generalization', ->
    nodeSpec = ['Super', 'Child']
    edgeSpec = [['Child', 'is_a', 'Super']]

    it 'should be parsed from super to child', ->
      g = new Graph
      parser.parse g, 'Super |>--> Child'
      expectEtalonGaph g, nodeSpec, edgeSpec

    it 'should be parsed from child to super', ->
      g = new Graph
      parser.parse g, 'Child <--<| Super'
      expectEtalonGaph g, nodeSpec, edgeSpec

    it 'should ignore duplicates', ->
      g = new Graph
      parser.parse g, 'Super |>--> Child'
      parser.parse g, 'Child <--<| Super'
      expectEtalonGaph g, nodeSpec, edgeSpec

  describe 'Aggregation', ->
    nodeSpec = ['Container', 'Member']
    edgeSpec = [['Container', 'has_a', 'Member']]

    it 'should be parsed from container to member', ->
      g = new Graph
      parser.parse g, 'Container <>--> Member'
      expectEtalonGaph g, nodeSpec, edgeSpec

    it 'should be parsed from member to container', ->
      g = new Graph
      parser.parse g, 'Member <--<> Container'
      expectEtalonGaph g, nodeSpec, edgeSpec

    it 'should ignore duplicates', ->
      g = new Graph
      parser.parse g, 'Container <>--> Member'
      parser.parse g, 'Member <--<> Container'
      expectEtalonGaph g, nodeSpec, edgeSpec

  describe 'Composition', ->
    nodeSpec = ['Owner', 'Member']
    edgeSpec = [['Owner', 'owns_a', 'Member']]

    it 'should be parsed from owner to member', ->
      g = new Graph
      parser.parse g, 'Owner <|>--> Member'
      expectEtalonGaph g, nodeSpec, edgeSpec

    it 'should be parsed from member to owner', ->
      g = new Graph
      parser.parse g, 'Member <--<|> Owner'
      expectEtalonGaph g, nodeSpec, edgeSpec

    it 'should ignore duplicates', ->
      g = new Graph
      parser.parse g, 'Owner <|>--> Member'
      parser.parse g, 'Member <--<|> Owner'
      expectEtalonGaph g, nodeSpec, edgeSpec

  describe 'Dependency', ->
    nodeSpec = ['User', 'Object']
    edgeSpec = [['User', 'uses_a', 'Object']]

    it 'should be parsed from user to object', ->
      g = new Graph
      parser.parse g, 'User - -> Object'
      expectEtalonGaph g, nodeSpec, edgeSpec

    it 'should be parsed from object to user', ->
      g = new Graph
      parser.parse g, 'Object <- - User'
      expectEtalonGaph g, nodeSpec, edgeSpec

    it 'should ignore duplicates', ->
      g = new Graph
      parser.parse g, 'User - -> Object'
      parser.parse g, 'Object <- - User'
      expectEtalonGaph g, nodeSpec, edgeSpec

  describe 'Mixed', ->
    it 'should contain all relationships and ignore blank lines', ->
      txt = """
                A |>--> B

                B <|>--> C
                A <--<> C
                B <- - D
            """
      g = new Graph
      parser.parse g, txt
      nodeSpec = ['A', 'B', 'C', 'D']
      edgeSpec = [['B', 'is_a', 'A'],
                  ['B', 'owns_a', 'C'],
                  ['C', 'has_a', 'A'],
                  ['D', 'uses_a', 'B']]
      expectEtalonGaph g, nodeSpec, edgeSpec
