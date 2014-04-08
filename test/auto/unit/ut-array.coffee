describe 'Array', ->
  describe 'Iteration:', ->
    describe 'Copy:', ->
      i = Iteration.Copy

      describe 'foldl', ->
        it 'should return a0 iterating through empty array', ->
          test_array = []
          a = i.forEach.from(test_array).reduce 4, (a, {x}) ->
            x - a

          expect(a).to.be.equal 4

        it 'should return correct value iterating through non-empty array', ->
          test_array = [10, -3]
          a = i.forEach.from(test_array).reduce 4, (a, {x}) ->
            x - a

          expect(a).to.be.equal -9

      describe 'foldr', ->
        it 'should return a0 iterating through empty array', ->
          test_array = []
          a = i.forEach.fromReversed(test_array).reduce 4, (a, {x}) ->
            x - a

          expect(a).to.be.equal 4

        it 'should return correct value iterating through non-empty array', ->
          test_array = [10, -3]
          a = i.forEach.fromReversed(test_array).reduce 4, (a, {x}) ->
            x - a

          expect(a).to.be.equal 17

      describe 'map', ->
        it 'should return empty array iterating through empty array', ->
          test_array = []
          r = i.forEach.from(test_array).map ({x}) ->
            -x

          expect(r).to.be.eql []
          expect(r).to.be.not.equal test_array

        it 'should return correct value iterating through non-empty array', ->
          test_array = [10, -3]
          r = i.forEach.from(test_array).map ({x}) ->
            -x

          expect(r).to.be.eql [-10, 3]
          expect(r).to.be.not.equal test_array

      describe 'rmap', ->
        it 'should return empty array iterating through empty array', ->
          test_array = []
          r = i.forEach.fromReversed(test_array).map ({x}) ->
            -x

          expect(r).to.be.eql []
          expect(r).to.be.not.equal test_array

        it 'should return correct value iterating through non-empty array', ->
          test_array = [10, -3]
          r = i.forEach.fromReversed(test_array).map ({x}) ->
            -x

          expect(r).to.be.eql [3, -10]
          expect(r).to.be.not.equal test_array

      describe 'forEach', ->
        it 'should not perform callback iterating through empty array', ->
          test_array = []
          r = []
          i.forEach.from(test_array).do ({x}) ->
            r.push(x)

          expect(r).to.be.eql []

        it 'should perform callback iterating through non-empty array', ->
          test_array = [10, -3]
          r = []
          i.forEach.from(test_array).do (x) ->
            r.push(x)

          expect(r).to.be.eql [{idx: 0, x: 10}, {idx: 1, x: -3}]

      describe 'filter', ->
        it 'should return empty array iterating through empty array', ->
          test_array = []
          r = i.forEach.from(test_array).filter ({x}) ->
            x > 0

          expect(r).to.be.eql []
          expect(r).to.be.not.equal test_array

        it 'should return correct value iterating through non-empty array', ->
          test_array = [10, -3]
          r = i.forEach.from(test_array).filter ({x}) ->
            x < 0

          expect(r).to.be.eql [-3]
          expect(r).to.be.not.equal test_array

      describe 'any', ->
        any = Iteration.Copy.any

        it 'should return false through empty array', ->
          test_array = []
          p = ({x}) ->
            x > 0

          expect(i.ifAny.from(test_array).is p).to.be.false

        it 'should return correct value iterating through non-empty array', ->
          test_array = [10, -3]
          p = ({x}) ->
            x > 10

          expect(i.ifAny.from(test_array).is p).to.be.false

        it 'should stop iterationg once result found', ->
          test_array = [10, -3, 5, -7]
          count = 0
          p = ({x}) ->
            ++count
            x < 0

          expect(i.ifAny.from(test_array).is p).to.be.true
          expect(count).to.be.equal 2

      describe 'all', ->
        it 'should return false through empty array', ->
          test_array = []
          p = ({x}) ->
            x > 0

          expect(i.ifEach.from(test_array).is p).to.be.false

        it 'should return correct value iterating through non-empty array', ->
          test_array = [10, -3]
          p = ({x}) ->
            x > -10

          expect(i.ifEach.from(test_array).is p).to.be.true

        it 'should stop iteration once result found', ->
          test_array = [10, -3, 5, -7]
          count = 0
          p = ({x}) ->
            ++count
            x > 0

          expect(i.ifEach.from(test_array).is p).to.be.false
          expect(count).to.be.equal 2

    describe 'Replace:', ->
      i = Iteration.Replace

      describe 'map', ->
        it 'should return empty array iterating through empty array', ->
          test_array = []
          r = i.forEach.from(test_array).map ({x}) ->
            -x

          expect(r).to.be.eql []
          expect(r).to.be.equal test_array

        it 'should return correct value iterating through non-empty array', ->
          test_array = [10, -3]
          r = i.forEach.from(test_array).map ({x}) ->
            -x

          expect(r).to.be.eql [-10, 3]
          expect(r).to.be.equal test_array

      describe 'filter', ->
        it 'should return empty array iterating through empty array', ->
          test_array = []
          r = i.forEach.from(test_array).filter ({x}) ->
            x > 0

          expect(r).to.be.eql []
          expect(r).to.be.equal test_array

        it 'should return correct value iterating through non-empty array', ->
          test_array = [10, -3]
          r = i.forEach.from(test_array).filter ({x}) ->
            x < 0

          expect(r).to.be.eql [-3]
          expect(r).to.be.equal test_array
