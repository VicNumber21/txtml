describe 'LinkedList:', ->
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

  describe 'Value insertion:', ->
    it '- append should work with empty list', ->
      test_list = new LinkedList
      test_list.append 5
      expect(test_list.length()).to.be.equal 1
      expect(test_list.toArray()).to.be.eql [5]
      expect(test_list.first().value()).to.be.equal 5
      expect(test_list.last().value()).to.be.equal 5

    it '- prepend should work with empty list', ->
      test_list = new LinkedList
      test_list.prepend 'test'
      expect(test_list.length()).to.be.equal 1
      expect(test_list.toArray()).to.be.eql ['test']
      expect(test_list.first().value()).to.be.equal 'test'
      expect(test_list.last().value()).to.be.equal 'test'

    it '- append should work with non-empty list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.append 5
      expect(test_list.length()).to.be.equal 4
      expect(test_list.toArray()).to.be.eql [1, 2, 3, 5]
      expect(test_list.first().value()).to.be.equal 1
      expect(test_list.last().value()).to.be.equal 5

    it '- prepend should work with non-empty list', ->
      test_list = new LinkedList ['abc', 'ok', 'nice']
      test_list.prepend 'test'
      expect(test_list.length()).to.be.equal 4
      expect(test_list.toArray()).to.be.eql ['test', 'abc', 'ok', 'nice']
      expect(test_list.first().value()).to.be.equal 'test'
      expect(test_list.last().value()).to.be.equal 'nice'

    it '- insertBefore should work with non-empty list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.insertBefore test_list.first().next(), 5
      expect(test_list.length()).to.be.equal 4
      expect(test_list.toArray()).to.be.eql [1, 5, 2, 3]
      expect(test_list.first().next().value()).to.be.equal 5
      expect(test_list.last().prev().prev().value()).to.be.equal 5

    it '- insertAfter should work with non-empty list', ->
      test_list = new LinkedList ['abc', 'ok', 'nice']
      test_list.insertAfter test_list.last().prev(), 'test'
      expect(test_list.length()).to.be.equal 4
      expect(test_list.toArray()).to.be.eql ['abc', 'ok', 'test', 'nice']
      expect(test_list.first().next().next().value()).to.be.equal 'test'
      expect(test_list.last().prev().value()).to.be.equal 'test'

  describe 'List insertion:', ->
    describe 'empty list', ->
      it '- should be appended correctly', ->
        test_list = new LinkedList [1, 2, 3]
        inserted_list = new LinkedList
        test_list.appendList inserted_list
        expect(test_list.length()).to.be.equal 3
        expect(test_list.toArray()).to.be.eql [1, 2, 3]

      it '- should be prepended correctly', ->
        test_list = new LinkedList [1, 2, 3]
        inserted_list = new LinkedList
        test_list.prependList inserted_list
        expect(test_list.length()).to.be.equal 3
        expect(test_list.toArray()).to.be.eql [1, 2, 3]

      it '- should be inserted before the particular iterator correctly', ->
        test_list = new LinkedList [1, 2, 3]
        inserted_list = new LinkedList
        test_list.insertListBefore test_list.first().next(), inserted_list
        expect(test_list.length()).to.be.equal 3
        expect(test_list.toArray()).to.be.eql [1, 2, 3]

      it '- should be inserted after the particular iterator correctly', ->
        test_list = new LinkedList [1, 2, 3]
        inserted_list = new LinkedList
        test_list.insertListAfter test_list.first().next(), inserted_list
        expect(test_list.length()).to.be.equal 3
        expect(test_list.toArray()).to.be.eql [1, 2, 3]

    describe 'non-reversed list', ->
      it '- should be appended correctly', ->
        test_list = new LinkedList [1, 2, 3]
        inserted_list = new LinkedList [7, 8, 9]
        test_list.appendList inserted_list
        expect(test_list.length()).to.be.equal 6
        expect(test_list.toArray()).to.be.eql [1, 2, 3, 7, 8, 9]
        expect(test_list.first().value()).to.be.equal 1
        expect(test_list.last().value()).to.be.equal 9

      it '- should be prepended correctly', ->
        test_list = new LinkedList [1, 2, 3]
        inserted_list = new LinkedList [7, 8, 9]
        test_list.prependList inserted_list
        expect(test_list.length()).to.be.equal 6
        expect(test_list.toArray()).to.be.eql [7, 8, 9, 1, 2, 3]
        expect(test_list.first().value()).to.be.equal 7
        expect(test_list.last().value()).to.be.equal 3

      it '- should be inserted before the particular iterator correctly', ->
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

      it '- should be inserted after the particular iterator correctly', ->
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

    describe 'reversed list', ->
      it '- should be appended correctly', ->
        test_list = new LinkedList [1, 2, 3]
        inserted_list = new LinkedList [7, 8, 9]
        test_list.appendList inserted_list.reverse()
        expect(test_list.length()).to.be.equal 6
        expect(test_list.toArray()).to.be.eql [1, 2, 3, 9, 8, 7]
        expect(test_list.first().value()).to.be.equal 1
        expect(test_list.last().value()).to.be.equal 7

      it '- should be prepended correctly', ->
        test_list = new LinkedList [1, 2, 3]
        inserted_list = new LinkedList [7, 8, 9]
        test_list.prependList inserted_list.reverse()
        expect(test_list.length()).to.be.equal 6
        expect(test_list.toArray()).to.be.eql [9, 8, 7, 1, 2, 3]
        expect(test_list.first().value()).to.be.equal 9
        expect(test_list.last().value()).to.be.equal 3

      it '- should be inserted before the particular iterator correctly', ->
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

      it '- should be inserted after the particular iterator correctly', ->
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

  describe 'Replacing', ->
    it 'should be fine with not dummy iterator', ->
      test_list = new LinkedList [1, 2, 3]
      old = test_list.replace test_list.first().next(), 5
      expect(old).to.be.equal 2
      expect(test_list.toArray()).to.be.eql [1, 5, 3]

    it 'should fail with begin iterator', ->
      test_list = new LinkedList [1, 2, 3]
      fn = () -> test_list.replace test_list.begin(), 5
      expect(fn).to.throw /Dummy node iterator/

    it 'should fine with end iterator', ->
      test_list = new LinkedList [1, 2, 3]
      fn = () -> test_list.replace test_list.end(), 5
      expect(fn).to.throw /Dummy node iterator/

  describe 'Removal', ->
    it 'should be fine with the first iterator of non-reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.remove test_list.first()
      expect(test_list.length()).to.be.equal 2
      expect(test_list.toArray()).to.be.eql [2, 3]
      expect(test_list.first().value()).to.be.equal 2

    it 'should be fine with the last iterator of non-reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.remove test_list.last()
      expect(test_list.length()).to.be.equal 2
      expect(test_list.toArray()).to.be.eql [1, 2]
      expect(test_list.last().value()).to.be.equal 2

    it 'should be fine with an iterator in the middle of non-reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.remove test_list.first().next()
      expect(test_list.length()).to.be.equal 2
      expect(test_list.toArray()).to.be.eql [1, 3]

    it 'should be fine with the first iterator of reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.reverse().remove test_list.first()
      expect(test_list.length()).to.be.equal 2
      expect(test_list.toArray()).to.be.eql [2, 1]
      expect(test_list.first().value()).to.be.equal 2

    it 'should be fine with the last iterator of reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.reverse().remove test_list.last()
      expect(test_list.length()).to.be.equal 2
      expect(test_list.toArray()).to.be.eql [3, 2]
      expect(test_list.last().value()).to.be.equal 2

    it 'should be fine with an iterator in the middle of reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      test_list.reverse().remove test_list.first().next()
      expect(test_list.length()).to.be.equal 2
      expect(test_list.toArray()).to.be.eql [3, 1]

    it 'should be fine with an iterator in just inserted non-reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.insertListAfter test_list.first().next(), inserted_list
      test_list.remove test_list.first().next().next().next()
      expect(test_list.length()).to.be.equal 5
      expect(test_list.toArray()).to.be.eql [1, 2, 7, 9, 3]

    it 'should be fine with an iterator in just inserted reversed list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.insertListAfter test_list.first().next(), inserted_list.reverse()
      test_list.remove test_list.first().next().next().next()
      expect(test_list.length()).to.be.equal 5
      expect(test_list.toArray()).to.be.eql [1, 2, 9, 7, 3]

    it 'should be fine with an iterator in just inserted list of length 1', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [5]
      test_list.insertListBefore test_list.first().next(), inserted_list
      test_list.remove test_list.first().next()
      expect(test_list.length()).to.be.equal 3
      expect(test_list.toArray()).to.be.eql [1, 2, 3]

    it 'should be fine if performed during iteration through the list', ->
      test_list = new LinkedList [1, 2, 3]
      inserted_list = new LinkedList [7, 8, 9]
      test_list.insertListBefore test_list.first().next(), inserted_list
      iter = test_list.first()
      [_, iter] = test_list.remove iter until iter.isDone()
      expect(test_list.length()).to.be.equal 0
      expect(test_list.toArray()).to.be.eql []

  describe 'Reversing', ->
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
      test_list.reverse().insertAfter test_list.last().prev(), 20
      test_list.reverse().insertBefore test_list.first().next().next().next().next(), 15
      expect(test_list.length()).to.be.equal 14
      expect(test_list.toArray()).to.be.eql [9, 20, 6, 10, 15, 11, 12, 8, 7, 5, 4, 3, 2, 1]

  describe 'Iteration', ->
    it 'should work in forward direction for empty list', ->
      test_list = new LinkedList
      iter = test_list.begin()
      count = 0
      ++count until (iter = iter.next()).isDone()
      expect(count).to.be.equal 0

    it 'should work in backward direction for empty list', ->
      test_list = new LinkedList
      iter = test_list.begin().reverse()
      count = 0
      ++count until (iter = iter.next()).isDone()
      expect(count).to.be.equal 0

    it 'should work in forward direction for non-reversed list', ->
      test_list = new LinkedList [1, 2, 3, 4, 5]
      iter = test_list.begin()
      acc = (iter.value() until (iter = iter.next()).isDone())
      expect(acc).to.be.eql [1, 2, 3, 4, 5]

    it 'should work in backward direction for non-reversed list', ->
      test_list = new LinkedList [1, 2, 3, 4, 5]
      iter = test_list.begin().reverse()
      acc = (iter.value() until (iter = iter.next()).isDone())
      expect(acc).to.be.eql [5, 4, 3, 2, 1]

    it 'should work in forward direction for reversed list', ->
      test_list = new LinkedList [1, 2, 3, 4, 5]
      iter = test_list.reverse().begin()
      acc = (iter.value() until (iter = iter.next()).isDone())
      expect(acc).to.be.eql [5, 4, 3, 2, 1]

    it 'should work in backward direction for reversed list', ->
      test_list = new LinkedList [1, 2, 3, 4, 5]
      iter = test_list.reverse().begin().reverse()
      acc = (iter.value() until (iter = iter.next()).isDone())
      expect(acc).to.be.eql [1, 2, 3, 4, 5]
