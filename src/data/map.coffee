iteration = require('data/iteration').Copy
clone = require('data/util').clone


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

  _hash: () =>
    @_hashes[@_idx]

  key: () =>
    @_owner._key @_hash()

  value: () =>
    @_owner._get @_hash()

  view: () =>
    key = @key()
    {key: key, x: @_owner._get key}

  reverse: () =>
    new _Iterator @_owner, @_hashes, @_idx , -@_step

  _removed: () =>
    @_hashes.splice @_idx, 1
    @


throwInvalidKey = () ->
  throw new Error 'Invalid key'

isSimple = (simple) ->
  type = typeof simple
  type is 'number' or type is 'string'

isIter = (obj) ->
  obj.prev? and obj.next? and obj.key? and obj.value? and obj.view?

isObject = (obj) ->
  obj? and (typeof obj is 'object')

iterToKey = (iter) ->
  {key: iter.key(), hash: iter._hash(), iter: iter}

simpleToKey = (simple) ->
  {key:simple, hash: (typeof simple) + '_' + simple}

objectToKey = (obj) ->
  if typeof obj.hash is 'function'
    hash = obj.hash()
    throwInvalidKey() unless isSimple hash
    key = clone(obj)
    key.hash = () -> hash
    {key: key, hash: 'object_' + simpleToKey(hash).hash}
  else
    throwInvalidKey() unless isSimple hash

toKey = (iterOrKey) ->
  if isSimple(iterOrKey)
    simpleToKey(iterOrKey)
  else if isObject(iterOrKey)
    if isIter(iterOrKey)
      iterToKey(iterOrKey)
    else
      objectToKey(iterOrKey)
  else
    throwInvalidKey()


class Map
  constructor: (init = []) ->
    @_hashTable = {}
    @set key, x for {key, x} in init

  get: (key) =>
    {hash} = toKey key
    @_get hash

  set: (key, x) =>
    {key, hash} = toKey key
    @_hashTable[hash] = {key: key, x: x}
    @_onModification()
    @

  remove: (iterOrKey) =>
    {hash, iter} = toKey iterOrKey
    x = @_get hash
    delete @_hashTable[hash]
    @_onModification()
    if iter? then [x, iter._removed()] else x

  contains: (key) =>
    {hash} = toKey key
    @_hashTable[hash] isnt undefined

  keys: () =>
    iteration.map @._hashes(), ({x}) =>
      @._key x

  values: () =>
    iteration.map @._hashes(), ({x}) =>
      @._get x

  begin: () =>
    new _Iterator @, @_hashes(), -1

  end: () =>
    keys = @_hashes()
    new _Iterator @, keys, keys.length

  first: () =>
    @begin().next()

  last: () =>
    @end().prev()

  length: () =>
    @_hashes().length

  isEmpty: () =>
    @length() is 0

  toArray: () =>
    iteration.foldl @, [], (acc, view) ->
      acc.push view
      acc

  cumulate: ({key, value}) =>
    @set key, value

  replace: (iter, x) =>
    @set iter.key(), x

  _get: (hash) =>
    @_hashTable[hash]?.x

  _key: (hash) =>
    @_hashTable[hash]?.key

  _hashes: () =>
    @_hashCache = Object.keys(@_hashTable) unless @_hashCache?
    @_hashCache

  _onModification: () =>
    delete @_hashCache


exports.Map = Map
