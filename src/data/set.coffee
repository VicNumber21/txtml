require 'data/array'
HashTable = require 'data/hashtable'
Hash = require 'data/hash'


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

  value: () =>
    @_htIter.value()

  view: () =>
    {x: @value()}

  reverse: () =>
    new _Iterator @_htIter.reverse()


class Set
  constructor: (init = []) ->
    @_hashTable = new HashTable
    @add x for x in init

  add: (x) =>
    hash = new Hash(x)
    @_hashTable.set hash.hash(), x
    @

  remove: (iterOrX) =>
    hash = new Hash(iterOrX)

    if hash.isIter()
      [value, iter] = @_hashTable.delete iterOrX._htIter
      [value, new _Iterator iter]
    else
      @_hashTable.remove hash.hash()

  contains: (x) =>
    hash = new Hash(x)
    @_hashTable.contains(hash.hash())

  values: () =>
    @_hashTable.get(hash) for hash in @_hashTable.hashes()

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
    Array::fromSequenceValue(@)

  cumulate: (x) =>
    @add x

  replace: (iter, x) =>
    removed = @_hashTable.remove iter.hash()
    @add  x
    removed


module.exports = Set
