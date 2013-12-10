describe 'LinkedList tests', ->
  describe 'Creation', ->
    it 'should be created from array', ->
      test_array = [1, 2, 3]
      test_list = new LinkedList test_array
      expect(test_list.toArray()).to.be.eql test_array
      expect(test_list.isEmpty()).to.be.false
      expect(test_list.length()).to.be.equal 3
      expect(test_list.first().value()).to.be.equal 1
      expect(test_list.last().value()).to.be.equal 3

    it 'should be empty by default', ->
      test_list = new LinkedList
      expect(test_list.toArray()).to.be.eql []
      expect(test_list.isEmpty()).to.be.true
      expect(test_list.length()).to.be.equal 0

  describe 'Insert value:', ->
    it '- appendValue should work with empty list', ->
      test_list = new LinkedList
      test_list.appendValue 5
      expect(test_list.length()).to.be.equal 1
      expect(test_list.toArray()).to.be.eql [5]
      expect(test_list.first().value()).to.be.equal 5
      expect(test_list.last().value()).to.be.equal 5

    it '- prependValue should work with empty list', ->
      test_list = new LinkedList
      test_list.prependValue 'test'
      expect(test_list.length()).to.be.equal 1
      expect(test_list.toArray()).to.be.eql ['test']
      expect(test_list.first().value()).to.be.equal 'test'
      expect(test_list.last().value()).to.be.equal 'test'

    it '- appendValue should work with non-empty list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.appendValue 5
      expect(test_list.length()).to.be.equal 4
      expect(test_list.toArray()).to.be.eql [1, 2, 3, 5]
      expect(test_list.first().value()).to.be.equal 1
      expect(test_list.last().value()).to.be.equal 5

    it '- prependValue should work with non-empty list', ->
      test_list = new LinkedList ['abc', 'ok', 'nice']
      test_list.prependValue 'test'
      expect(test_list.length()).to.be.equal 4
      expect(test_list.toArray()).to.be.eql ['test', 'abc', 'ok', 'nice']
      expect(test_list.first().value()).to.be.equal 'test'
      expect(test_list.last().value()).to.be.equal 'nice'

    it '- insertValueBefore should work with non-empty list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.insertValueBefore test_list.first().next(), 5
      expect(test_list.length()).to.be.equal 4
      expect(test_list.toArray()).to.be.eql [1, 5, 2, 3]
      expect(test_list.first().next().value()).to.be.equal 5
      expect(test_list.last().prev().prev().value()).to.be.equal 5

    it '- insertValueAfter should work with non-empty list', ->
      test_list = new LinkedList ['abc', 'ok', 'nice']
      test_list.insertValueAfter test_list.last().prev(), 'test'
      expect(test_list.length()).to.be.equal 4
      expect(test_list.toArray()).to.be.eql ['abc', 'ok', 'test', 'nice']
      expect(test_list.first().next().next().value()).to.be.equal 'test'
      expect(test_list.last().prev().value()).to.be.equal 'test'

  describe 'Insert list:', ->
    it '- appendList should work with non-reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.appendList inserted_list
      expect(test_list.length()).to.be.equal 6
      expect(test_list.toArray()).to.be.eql [1, 2, 3, 7, 8, 9]
      expect(test_list.first().value()).to.be.equal 1
      expect(test_list.last().value()).to.be.equal 9

    it '- prependList should work with non-reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.prependList inserted_list
      expect(test_list.length()).to.be.equal 6
      expect(test_list.toArray()).to.be.eql [7, 8, 9, 1, 2, 3]
      expect(test_list.first().value()).to.be.equal 7
      expect(test_list.last().value()).to.be.equal 3

    it '- insertListBefore should work with non-reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.insertListBefore test_list.first().next(), inserted_list
      expect(test_list.length()).to.be.equal 6
      expect(test_list.toArray()).to.be.eql [1, 7, 8, 9, 2, 3]
      expect(test_list.first().value()).to.be.equal 1
      expect(test_list.first().next().value()).to.be.equal 7
      expect(test_list.first().next().next().next().next().value()).to.be.equal 2
      expect(test_list.last().prev().value()).to.be.equal 2
      expect(test_list.last().prev().prev().value()).to.be.equal 9
      expect(test_list.last().prev().prev().prev().prev().prev().value()).to.be.equal 1

    it '- insertListAfter should work with non-reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.insertListAfter test_list.first().next(), inserted_list
      expect(test_list.length()).to.be.equal 6
      expect(test_list.toArray()).to.be.eql [1, 2, 7, 8, 9, 3]
      expect(test_list.first().next().value()).to.be.equal 2
      expect(test_list.first().next().next().value()).to.be.equal 7
      expect(test_list.first().next().next().next().next().next().value()).to.be.equal 3
      expect(test_list.last().value()).to.be.equal 3
      expect(test_list.last().prev().value()).to.be.equal 9
      expect(test_list.last().prev().prev().prev().prev().value()).to.be.equal 2

    it '- appendList should work with reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.appendList inserted_list.reverse()
      expect(test_list.length()).to.be.equal 6
      expect(test_list.toArray()).to.be.eql [1, 2, 3, 9, 8, 7]
      expect(test_list.first().value()).to.be.equal 1
      expect(test_list.last().value()).to.be.equal 7

    it '- prependList should work with reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.prependList inserted_list.reverse()
      expect(test_list.length()).to.be.equal 6
      expect(test_list.toArray()).to.be.eql [9, 8, 7, 1, 2, 3]
      expect(test_list.first().value()).to.be.equal 9
      expect(test_list.last().value()).to.be.equal 3

    it '- insertListBefore should work with reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.insertListBefore test_list.first().next(), inserted_list.reverse()
      expect(test_list.length()).to.be.equal 6
      expect(test_list.toArray()).to.be.eql [1, 9, 8, 7, 2, 3]
      expect(test_list.first().value()).to.be.equal 1
      expect(test_list.first().next().value()).to.be.equal 9
      expect(test_list.first().next().next().next().next().value()).to.be.equal 2
      expect(test_list.last().prev().value()).to.be.equal 2
      expect(test_list.last().prev().prev().value()).to.be.equal 7
      expect(test_list.last().prev().prev().prev().prev().prev().value()).to.be.equal 1

    it '- insertListAfter should work with reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.insertListAfter test_list.first().next(), inserted_list.reverse()
      expect(test_list.length()).to.be.equal 6
      expect(test_list.toArray()).to.be.eql [1, 2, 9, 8, 7, 3]
      expect(test_list.first().next().value()).to.be.equal 2
      expect(test_list.first().next().next().value()).to.be.equal 9
      expect(test_list.first().next().next().next().next().next().value()).to.be.equal 3
      expect(test_list.last().value()).to.be.equal 3
      expect(test_list.last().prev().value()).to.be.equal 7
      expect(test_list.last().prev().prev().prev().prev().value()).to.be.equal 2

  describe 'Reverse', ->
    it 'should work for empty list', ->
      test_list = new LinkedList
      test_list.reverse()
      expect(test_list.toArray()).to.be.eql []

    it 'should work for non-empty list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.reverse()
      expect(test_list.toArray()).to.be.eql [3, 2, 1]
      expect(test_list.first().value()).to.be.equal 3
      expect(test_list.last().value()).to.be.equal 1

    it 'should work with inserted lists', ->
      test_list = new LinkedList [1, 2, 3]
      list1 = new LinkedList [4, 5]
      list2 = new LinkedList [6]
      list3 = new LinkedList [7, 8, 9]
      list4 = new LinkedList [10, 11, 12]
      test_list.appendList(list1).reverse().prependList list3.reverse()
      test_list.reverse().insertListAfter test_list.last().prev(), list4.reverse()
      test_list.reverse().insertListBefore test_list.first().next(), list2
      test_list.reverse().insertValueAfter test_list.last().prev(), 20
      test_list.reverse().insertValueBefore test_list.first().next().next().next().next(), 15
      expect(test_list.length()).to.be.equal 14
      expect(test_list.toArray()).to.be.eql [9, 20, 6, 10, 15, 11, 12, 8, 7, 5, 4, 3, 2, 1]

