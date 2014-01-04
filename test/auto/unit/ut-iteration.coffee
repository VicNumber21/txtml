describe 'Iteration:', ->
  describe 'Copy:', ->
    describe 'foldl', ->
      foldl = Iteration.Copy.foldl

      it 'should return a0 iterating through empty list', ->
        test_list = new LinkedList
        a = foldl test_list, 4, (a, x) ->
          x - a

        expect(a).to.be.equal 4

      it 'should return correct value iterating through non-empty list', ->
        test_list = new LinkedList [10, -3]
        a = foldl test_list, 4, (a, x) ->
          x - a

        expect(a).to.be.equal -9

    describe 'foldr', ->
      foldr = Iteration.Copy.foldr

      it 'should return a0 iterating through empty list', ->
        test_list = new LinkedList
        a = foldr test_list, 4, (x, a) ->
          x - a

        expect(a).to.be.equal 4

      it 'should return correct value iterating through non-empty list', ->
        test_list = new LinkedList [10, -3]
        a = foldr test_list, 4, (x, a) ->
          x - a

        expect(a).to.be.equal 17

    describe 'map', ->
      map = Iteration.Copy.map

      it 'should return empty list iterating through empty list', ->
        test_list = new LinkedList
        r = map test_list, (x) ->
          -x

        expect(r.toArray()).to.be.eql []
        expect(r).to.be.not.equal test_list

      it 'should return correct value iterating through non-empty list', ->
        test_list = new LinkedList [10, -3]
        r = map test_list, (x) ->
          -x

        expect(r.toArray()).to.be.eql [-10, 3]
        expect(r).to.be.not.equal test_list

    describe 'rmap', ->
      rmap = Iteration.Copy.rmap

      it 'should return empty list iterating through empty list', ->
        test_list = new LinkedList
        r = rmap test_list, (x) ->
          -x

        expect(r.toArray()).to.be.eql []
        expect(r).to.be.not.equal test_list

      it 'should return correct value iterating through non-empty list', ->
        test_list = new LinkedList [10, -3]
        r = rmap test_list, (x) ->
          -x

        expect(r.toArray()).to.be.eql [3, -10]
        expect(r).to.be.not.equal test_list

    describe 'forEach', ->
      forEach = Iteration.Copy.forEach

      it 'should not perform callback iterating through empty list', ->
        test_list = new LinkedList
        r = []
        forEach test_list, (x) ->
          r.push(x)

        expect(r).to.be.eql []

      it 'should perform callback iterating through non-empty list', ->
        test_list = new LinkedList [10, -3]
        r = []
        forEach test_list, (x) ->
          r.push(x)

        expect(r).to.be.eql [10, -3]

    describe 'filter', ->
      filter = Iteration.Copy.filter

      it 'should return empty list iterating through empty list', ->
        test_list = new LinkedList
        r = filter test_list, (x) ->
          x > 0

        expect(r.toArray()).to.be.eql []
        expect(r).to.be.not.equal test_list

      it 'should return correct value iterating through non-empty list', ->
        test_list = new LinkedList [10, -3]
        r = filter test_list, (x) ->
          x > 0

        expect(r.toArray()).to.be.eql [10]
        expect(r).to.be.not.equal test_list

    describe 'any', ->
      any = Iteration.Copy.any

      it 'should return false through empty list', ->
        test_list = new LinkedList
        p = (x) ->
          x > 0
        expect(any test_list, p).to.be.false

      it 'should return correct value iterating through non-empty list', ->
        test_list = new LinkedList [10, -3]
        p = (x) ->
          x > 0
        expect(any test_list, p).to.be.true

      it 'should stop iterationg once result found', ->
        test_list = new LinkedList [10, -3, 5, -7]
        count = 0
        p = (x) ->
          ++count
          x < 0
        expect(any test_list, p).to.be.true
        expect(count).to.be.equal 2

    describe 'all', ->
      all = Iteration.Copy.all

      it 'should return false through empty list', ->
        test_list = new LinkedList
        p = (x) ->
          x > 0
        expect(all test_list, p).to.be.false

      it 'should return correct value iterating through non-empty list', ->
        test_list = new LinkedList [10, -3]
        p = (x) ->
          x > 0
        expect(all test_list, p).to.be.false

      it 'should stop iterationg once result found', ->
        test_list = new LinkedList [10, -3, 5, -7]
        count = 0
        p = (x) ->
          ++count
          x > 0
        expect(all test_list, p).to.be.false
        expect(count).to.be.equal 2

  describe 'Replace:', ->
    describe 'map', ->
      map = Iteration.Replace.map

      it 'should return empty list iterating through empty list', ->
        test_list = new LinkedList
        r = map test_list, (x) ->
          -x

        expect(r.toArray()).to.be.eql []
        expect(r).to.be.equal test_list

      it 'should return correct value iterating through non-empty list', ->
        test_list = new LinkedList [10, -3]
        r = map test_list, (x) ->
          -x

        expect(r.toArray()).to.be.eql [-10, 3]
        expect(r).to.be.equal test_list

    describe 'filter', ->
      filter = Iteration.Replace.filter

      it 'should return empty list iterating through empty list', ->
        test_list = new LinkedList
        r = filter test_list, (x) ->
          x > 0

        expect(r.toArray()).to.be.eql []
        expect(r).to.be.equal test_list

      it 'should return correct value iterating through non-empty list', ->
        test_list = new LinkedList [10, -3]
        r = filter test_list, (x) ->
          x > 0

        expect(r.toArray()).to.be.eql [10]
        expect(r).to.be.equal test_list
