describe 'Set:', ->
  class TestObject
    constructor: (@_hash = '1') ->

    hash: () ->
      @_hash


  describe 'Creation', ->
    it 'should be created from array', ->
      test_set = new Set [1, '1', new TestObject, 5]

      expect(test_set.length()).to.be.equal 4
      expect(test_set.isEmpty()).to.be.false

    it 'should be empty by default', ->
      test_set = new Set
      expect(test_set.isEmpty()).to.be.true
      expect(test_set.length()).to.be.equal 0
      expect(test_set.toArray()).to.be.eql []

    it 'should throw "Non-hashable value" if any key is not valid type', ->
      fn = () -> new Set ['a', null]
      expect(fn).to.throw /Non-hashable value/

  describe 'Add', ->
    it 'should add the value', ->
      test_set = new Set
      test_data = [1, '1', new TestObject]

      for x, idx in test_data
        expect(test_set.add x).to.be.equal test_set
        expect(test_set.length()).to.be.equal idx + 1
        expect(test_set.contains x).to.be.true

    it 'should throw "Non-hashable value" if the values is not hashable', ->
      test_set = new Set
      fn = () -> test_set.add undefined
      expect(fn).to.throw /Non-hashable value/

  describe 'Remove', ->
    it 'should remove the value from set', ->
      test_set = new Set [1, '1', new TestObject, 4]

      expect(test_set.remove 1).to.be.equal 1
      expect(test_set.length()).to.be.equal 3
      expect(test_set.contains 1).to.be.false

    it 'should remove the value for the iterator', ->
      test_set = new Set [1, 4]

      test_set.remove test_set.first()
      expect(test_set.length()).to.be.equal 1
      expect(test_set.contains 1).to.be.false

    it 'should throw "Non-hashable value" if the value is not hashable', ->
      test_set = new Set
      fn = () -> test_set.remove {}
      expect(fn).to.throw /Non-hashable value/

    it 'should return undefined if the value is not found', ->
      test_set = new Set [1, 4]

      expect(test_set.remove 7).to.be.undefined

    it 'should be fine if performed during iteration', ->
      test_set = new Set [1, 3, 4]

      iter = test_set.first()

      until iter.isDone()
        val = iter.value()
        [x, iter] = test_set.remove iter
        expect(x).to.be.equal val

  describe 'Contains', ->
    it 'should return true if the value is found', ->
      test_object = new TestObject
      test_set = new Set [1, '1', test_object, 4]

      expect(test_set.contains 1).to.be.true
      expect(test_set.contains '1').to.be.true
      expect(test_set.contains test_object).to.be.true
      expect(test_set.contains 4).to.be.true

    it 'should return false if the value is not found', ->
      test_set = new Set [1, '1', (new TestObject 1), 4]

      expect(test_set.contains 2).to.be.false
      expect(test_set.contains '3').to.be.false
      expect(test_set.contains new TestObject '1').to.be.false

    it 'should throw "Non-hashable value" if key is not valid type', ->
      test_set = new Set
      fn = () -> test_set.contains {}
      expect(fn).to.throw /Non-hashable value/

  describe 'Values', ->
    it 'should return empty array if the set is empty', ->
      test_set = new Set
      expect(test_set.values()).to.be.eql []

    it 'should return values if the set is not empty', ->
      test_object = new TestObject 1
      test_data = [1, '1', test_object, 4].sort()
      test_set = new Set test_data
      values = test_set.values()
      expect(values.length).to.be.equal 4
      values.sort()
      expect(values).to.be.eql test_data

  describe 'Iteration:', ->
    describe 'Copy:', ->
      i = Iteration.Copy

      describe 'foldl', ->
        it 'should return a0 iterating through empty set', ->
          test_set = new Set
          a = i.forEach.from(test_set).reduce 4, (a, {x}) ->
            x - a

          expect(a).to.be.equal 4

        it 'should return correct value iterating through non-empty set', ->
          test_set = new Set [10, -3]
          a = i.forEach.from(test_set).reduce 4, (a, {x}) ->
            x - a

          expect(a).to.be.equal -9

      describe 'foldr', ->
        it 'should return a0 iterating through empty set', ->
          test_set = new Set
          a = i.forEach.fromReversed(test_set).reduce 4, (a, {x}) ->
            x - a

          expect(a).to.be.equal 4

        it 'should return correct value iterating through non-empty set', ->
          test_set = new Set [10, -3]
          a = i.forEach.fromReversed(test_set).reduce 4, (a, {x}) ->
            x - a

          expect(a).to.be.equal 17

      describe 'map', ->
        it 'should return empty set iterating through empty set', ->
          test_set = new Set
          r = i.forEach.from(test_set).map ({x}) ->
            -x

          expect(r.toArray()).to.be.eql []
          expect(r).to.be.not.equal test_set

        it 'should return correct value iterating through non-empty set', ->
          test_set = new Set [10, -3]
          r = i.forEach.from(test_set).map ({x}) ->
            -x

          expect(r.toArray()).to.be.eql [-10, 3]
          expect(r).to.be.not.equal test_set

      describe 'rmap', ->
        it 'should return empty set iterating through empty set', ->
          test_set = new Set
          r = i.forEach.fromReversed(test_set).map ({x}) ->
            -x

          expect(r.toArray()).to.be.eql []
          expect(r).to.be.not.equal test_set

        it 'should return correct value iterating through non-empty set', ->
          test_set = new Set [10, -3]
          r = i.forEach.fromReversed(test_set).map ({x}) ->
            -x

          expect(r.toArray()).to.be.eql [3, -10]
          expect(r).to.be.not.equal test_set

      describe 'forEach', ->
        it 'should not perform callback iterating through empty set', ->
          test_set = new Set
          r = []
          i.forEach.from(test_set).do ({x}) ->
            r.push(x)

          expect(r).to.be.eql []

        it 'should perform callback iterating through non-empty set', ->
          test_set = new Set [10, -3]
          r = []
          i.forEach.from(test_set).do ({x}) ->
            r.push(x)

          expect(r).to.be.eql [10, -3]

      describe 'filter', ->
        it 'should return empty set iterating through empty set', ->
          test_set = new Set
          r = i.forEach.from(test_set).filter ({x}) ->
            x > 0

          expect(r.toArray()).to.be.eql []
          expect(r).to.be.not.equal test_set

        it 'should return correct value iterating through non-empty set', ->
          test_set = new Set [10, -3]
          r = i.forEach.from(test_set).filter ({x}) ->
            x > 0

          expect(r.toArray()).to.be.eql [10]
          expect(r).to.be.not.equal test_set

      describe 'any', ->
        it 'should return false through empty set', ->
          test_set = new Set
          p = ({x}) ->
            x > 0

          expect(i.ifAny.from(test_set).is p).to.be.false

        it 'should return correct value iterating through non-empty set', ->
          test_set = new Set [10, -3]
          p = ({x}) ->
            x > 0

          expect(i.ifAny.from(test_set).is p).to.be.true

        it 'should stop iterationg once result found', ->
          test_set = new Set [10, -3, 5, -7]
          count = 0
          p = ({x}) ->
            ++count
            x < 0

          expect(i.ifAny.from(test_set).is p).to.be.true
          expect(count).to.be.equal 2

      describe 'all', ->
        it 'should return false through empty set', ->
          test_set = new Set
          p = ({x}) ->
            x > 0

          expect(i.ifEach.from(test_set).is p).to.be.false

        it 'should return correct value iterating through non-empty set', ->
          test_set = new Set [10, -3]
          p = ({x}) ->
            x > 0

          expect(i.ifEach.from(test_set).is p).to.be.false

        it 'should stop iterationg once result found', ->
          test_set = new Set [10, -3, 5, -7]
          count = 0
          p = ({x}) ->
            ++count
            x > 0

          expect(i.ifEach.from(test_set).is p).to.be.false
          expect(count).to.be.equal 2

    describe 'Replace:', ->
      i = Iteration.Replace

      describe 'map', ->
        it 'should return empty set iterating through empty set', ->
          test_set = new Set
          r = i.forEach.from(test_set).map ({x}) ->
            -x

          expect(r.toArray()).to.be.eql []
          expect(r).to.be.equal test_set

        it 'should return correct value iterating through non-empty set', ->
          test_set = new Set [10, -3]
          r = i.forEach.from(test_set).map ({x}) ->
            -x

          expect(r.toArray()).to.be.eql [-10, 3]
          expect(r).to.be.equal test_set

      describe 'filter', ->
        it 'should return empty set iterating through empty set', ->
          test_set = new Set
          r = i.forEach.from(test_set).filter ({x}) ->
            x > 0

          expect(r.toArray()).to.be.eql []
          expect(r).to.be.equal test_set

        it 'should return correct value iterating through non-empty set', ->
          test_set = new Set [10, -3]
          r = i.forEach.from(test_set).filter ({x}) ->
            x > 0

          expect(r.toArray()).to.be.eql [10]
          expect(r).to.be.equal test_set
