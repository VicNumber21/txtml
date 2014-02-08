iteration = require('data/iteration').Copy
require('data/array')
HashTable = require('data/hashtable').HashTable
Hash = require('data/hash').Hash


class _Iterator
  constructor: (@_htIter) ->

  prev: () =>
    new _Iterator @_htIter.prev()

  next: () =>
    new _Iterator @_htIter.next()

  isDone: () =>
    @_htIter.isDone()

  hash: () =>
    @_htIter.hash()

  key: () =>
    @view().key

  value: () =>
    @view().x

  view: () =>
    @_htIter.value()

  reverse: () =>
    new _Iterator @_htIter.reverse()


class Map
  constructor: (init = []) ->
    @_hashTable = new HashTable
    @set key, x for {key, x} in init

  get: (key) =>
    hash = new Hash(key)
    @_hashTable.get(hash.hash())?.x

  set: (key, x) =>
    hash = new Hash(key)
    @_hashTable.set hash.hash(), {key: hash.keyClone(), x: x}
    @

  remove: (iterOrKey) =>
    hash = new Hash(iterOrKey)

    if hash.isIter()
      [value, iter] = @_hashTable.delete iterOrKey._htIter
      [value?.x, new _Iterator iter]
    else
      @_hashTable.remove(hash.hash())?.x

  contains: (key) =>
    hash = new Hash(key)
    @_hashTable.contains(hash.hash())

  keys: () =>
    iteration.map @_hashTable.hashes(), ({x}) =>
      @_hashTable.get(x).key

  values: () =>
    iteration.map @_hashTable.hashes(), ({x}) =>
      @_hashTable.get(x).x

  begin: () =>
    new _Iterator @_hashTable.begin()

  end: () =>
    new _Iterator @_hashTable.end()

  first: () =>
    @begin().next()

  last: () =>
    @end().prev()

  length: () =>
    @_hashTable.length()

  isEmpty: () =>
    @_hashTable.isEmpty()

  toArray: () =>
    Array::fromSequenceView(@)

  cumulate: ({key, x}) =>
    @set key, x

  replace: (iter, x) =>
    @set iter, x


exports.Map = Map
