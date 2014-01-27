describe 'Map:', ->
  class TestKey
    constructor: (@_hash = '1') ->

    hash: () ->
      @_hash


  describe 'Creation', ->
    it 'should be created from array', ->
      test_map = new Map [{key: 1, x: 4},
                          {key: '1', x: 'test'},
                          {key: new TestKey, x: null},
                          {key: 4, x: undefined}]

      expect(test_map.length()).to.be.equal 4
      expect(test_map.isEmpty()).to.be.false

    it 'should be empty by default', ->
      test_map = new Map
      expect(test_map.isEmpty()).to.be.true
      expect(test_map.length()).to.be.equal 0
      expect(test_map.toArray()).to.be.eql []

    it 'should throw "Invalid key" if any key is not valid type', ->
      fn = () -> new Map [{key: 'a', x: 'b'}, {key: null, x: 5}]
      expect(fn).to.throw /Invalid key/

  describe 'Get', ->
    it 'should return contained value', ->
      test_key = new TestKey
      test_map = new Map [{key: 1, x: 4},
                          {key: '1', x: 'test'},
                          {key: test_key, x: null},
                          {key: 4, x: undefined}]

      expect(test_map.get 1).to.be.equal 4
      expect(test_map.get '1').to.be.equal 'test'
      expect(test_map.get test_key).to.be.equal null
      expect(test_map.get 4).to.be.equal undefined

    it 'should return undefined if no key found', ->
      test_map = new Map
      expect(test_map.get 1).to.be.equal undefined
      expect(test_map.get 'key').to.be.equal undefined
      expect(test_map.get new TestKey).to.be.equal undefined

    it 'should throw "Invalid key" if key is not valid type', ->
      test_map = new Map
      fn = () -> test_map.get {}
      expect(fn).to.throw /Invalid key/

  describe 'Set', ->
    it 'should set the value for the key', ->
      test_map = new Map
      test_data = [{key: 1, x: 4},
                   {key: '1', x: 'test'},
                   {key: new TestKey, x: null}]

      for {key, x}, idx in test_data
        expect(test_map.set key, x).to.be.equal test_map
        expect(test_map.length()).to.be.equal idx + 1
        expect(test_map.get key).to.be.equal x

    it 'should throw "Invalid key" if key is not valid type', ->
      test_map = new Map
      fn = () -> test_map.set undefined, 7
      expect(fn).to.throw /Invalid key/

    it 'should update the value for the key', ->
      test_map = new Map [{key: 1, x: 4},
                          {key: '1', x: 'test'},
                          {key: new TestKey, x: null},
                          {key: 4, x: undefined}]

      test_map.set 1, 'updated'
      expect(test_map.length()).to.be.equal 4
      expect(test_map.get 1).to.be.equal 'updated'

  describe 'Remove', ->
    it 'should remove the value for the key', ->
      test_map = new Map [{key: 1, x: 4},
                          {key: '1', x: 'test'},
                          {key: new TestKey, x: null},
                          {key: 4, x: undefined}]

      expect(test_map.remove 1).to.be.equal 4
      expect(test_map.length()).to.be.equal 3
      expect(test_map.contains 1).to.be.false

    it 'should remove the value for the iterator', ->
      test_map = new Map [{key: 1, x: 4},
                          {key: 4, x: undefined}]

      test_map.remove test_map.first()
      expect(test_map.length()).to.be.equal 1
      expect(test_map.contains 1).to.be.false

    it 'should throw "Invalid key" if key is not valid type', ->
      test_map = new Map
      fn = () -> test_map.remove {}
      expect(fn).to.throw /Invalid key/

    it 'should return undefined if the key is not found', ->
      test_map = new Map [{key: 1, x: 4},
                          {key: 4, x: 'test'}]

      expect(test_map.remove 7).to.be.undefined

    it 'should be fine if performed during iteration', ->
      test_map = new Map [{key: 1, x: 4},
                          {key: 3, x: 8},
                          {key: 4, x: undefined}]

      iter = test_map.first()

      until iter.isDone()
        val = iter.value()
        [x, iter] = test_map.remove iter
        expect(x).to.be.equal val

  describe 'Contains', ->
    it 'should return true if the key is found', ->
      test_key = new TestKey
      test_map = new Map [{key: 1, x: 4},
                          {key: '1', x: 'test'},
                          {key: test_key, x: null},
                          {key: 4, x: undefined}]

      expect(test_map.contains 1).to.be.true
      expect(test_map.contains '1').to.be.true
      expect(test_map.contains test_key).to.be.true
      expect(test_map.contains 4).to.be.true

    it 'should return false if the key is not found', ->
      test_map = new Map [{key: 1, x: 4},
                          {key: '1', x: 'test'},
                          {key: (new TestKey 1), x: null},
                          {key: 4, x: undefined}]

      expect(test_map.contains 2).to.be.false
      expect(test_map.contains '3').to.be.false
      expect(test_map.contains new TestKey '1').to.be.false

    it 'should throw "Invalid key" if key is not valid type', ->
      test_map = new Map
      fn = () -> test_map.contains {}
      expect(fn).to.throw /Invalid key/

  describe 'Keys', ->
    it 'should return empty array if the map is empty', ->
      test_map = new Map
      expect(test_map.keys()).to.be.eql []

    it 'should return key clones if the map is not empty', ->
      test_key = new TestKey 1
      test_map = new Map [{key: 1, x: 4},
                           {key: '5', x: 'test'},
                           {key: test_key, x: null},
                           {key: 4, x: undefined}]

      keys = test_map.keys()

      expect(keys.length).to.be.equal 4

      k = keys.concat([1, '5', test_key, 4])
      k.sort()
      not_expected_keys = []

      for i in [0..7] by 2 when k[i] isnt k[i + 1] and (not k[i]._hash or k[i]._hash isnt k[i + 1]._hash)
        not_expected_keys.push [k[i], k[i + 1]]

      expect(not_expected_keys).to.be.eql []

  describe 'Values', ->
    it 'should return empty array if the map is empty', ->
      test_map = new Map
      expect(test_map.values()).to.be.eql []

    it 'should return values if the map is not empty', ->
      test_key = new TestKey 1
      test_map = new Map [{key: 1, x: 4},
                           {key: '1', x: 'test'},
                           {key: test_key, x: test_key},
                           {key: 4, x: 9}]

      values = test_map.values()
      expect(values.length).to.be.equal 4

      v = values.concat [4, 'test', test_key, 9]
      v.sort()
      not_expected_values = []

      for i in [0..7] by 2 when v[i] isnt v[i + 1]
        not_expected_values.push [v[i], v[i + 1]]

      expect(not_expected_values).to.be.eql []

  describe 'Iterator:', ->
    it 'key() should return initial keys instead of internal ones', ->
      test_key = new TestKey
      test_map = new Map [{key: 1, x: 4},
                          {key: '1', x: 'test'},
                          {key: test_key, x: null},
                          {key: 4, x: undefined}]

      keys = [1, '1', 4]
      objectFound = false
      iter = test_map.begin()

      until (iter = iter.next()).isDone()
        currentKey = iter.key()

        if typeof currentKey is 'object'
          objectFound = true
          currentKey = currentKey.hash()

        expect(keys).to.contain currentKey

      expect(objectFound).to.be.true

    it 'view() should return initial keys instead of internal ones', ->
      test_key = new TestKey
      test_map = new Map [{key: 1, x: 4},
                          {key: '1', x: 'test'},
                          {key: test_key, x: null},
                          {key: 4, x: undefined}]

      keys = [1, '1', 4]
      objectFound = false
      iter = test_map.begin()

      until (iter = iter.next()).isDone()
        currentKey = iter.view().key

        if typeof currentKey is 'object'
          objectFound = true
          currentKey = currentKey.hash()

        expect(keys).to.contain currentKey

      expect(objectFound).to.be.true
