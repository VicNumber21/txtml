require 'data/array'


class _Iterator
  constructor: (@_owner, @_hashes, @_idx, @_step = 1) ->

  prev: () =>
    new _Iterator @_owner, @_hashes, @_idx - @_step, @_step

  next: () =>
    new _Iterator @_owner, @_hashes, @_idx + @_step, @_step

  isDone: () =>
    if @_step > 0
      @_idx >= @_hashes.length
    else
      @_idx < 0

  hash: () =>
    @_hashes[@_idx]

  value: () =>
    @_owner.get @hash()

  view: () =>
    hash = @hash()
    {hash: hash, x: @_owner.get hash}

  reverse: () =>
    new _Iterator @_owner, @_hashes, @_idx , -@_step

  _removed: () =>
    @_hashes.splice @_idx, 1
    @


class HashTable
  constructor: ()->
    @_hashTable = {}

  get: (hash) =>
    @_hashTable[hash]

  set: (hash, x) =>
    @_hashTable[hash] = x
    @_onModification()
    @

  remove: (hash) =>
    x = @get hash
    delete @_hashTable[hash]
    @_onModification()
    x

  delete: (iter) =>
    x = @remove(iter.hash())
    [x, iter._removed()]

  contains: (hash) =>
    @get(hash) isnt undefined

  hashes: () =>
    @_hashCache ?= Object.keys(@_hashTable)
    @_hashCache

  begin: () =>
    new _Iterator @, @hashes(), -1

  end: () =>
    hashes = @hashes()
    new _Iterator @, hashes, hashes.length

  first: () =>
    @begin().next()

  last: () =>
    @end().prev()

  length: () =>
    @hashes().length

  isEmpty: () =>
    @length() is 0

  toArray: () =>
    Array::fromSequenceView(@)

  cumulate: ({hash, x}) =>
    @set hash, x

  replace: (iter, x) =>
    @set iter.hash(), x

  _onModification: () =>
    delete @_hashCache


module.exports = HashTable
