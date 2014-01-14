foldl = require('data/iteration').Copy.foldl

class _Iterator
  constructor: (@_owner, @_keys, @_idx, @_step = 1) ->

  prev: () =>
    new _Iterator @_owner, @_keys, @_idx - @_step, @_step

  next: () =>
    new _Iterator @_owner, @_keys, @_idx + @_step, @_step

  isDone: () =>
    if @_step > 0
      @_idx >= @_keys.length
    else
      @_idx < 0

  key: () =>
    @_keys[@_idx]

  value: () =>
    @_owner._get @key()

  view: () =>
    key = @key()
    {key: key, x: @_owner._get key}

  reverse: () =>
    new _Iterator @_owner, @_keys, @_idx , -@_step

  _removed: () =>
    @_keys.splice @_idx, 1
    @


toKey = (iterOrKey) ->
  ik = iterOrKey
  type = typeof ik
  type2 = ''
  isObject = ik? and (type is 'object')
  iter = ik if isObject and ik.prev? and ik.next? and ik.key? and ik.value? and ik.view?

  key = if iter?
          iter.key()
        else
          ik = ik.hash() if isObject and (typeof ik.hash is 'function')
          keyType = typeof ik
          type2 = keyType + '_' if isObject
          type + '_' + type2 + ik if keyType is 'number' or keyType is 'string'

  throw new Error 'Invalid key' unless key?
  {key: key, iter: iter}


class Map
  constructor: (init = []) ->
    @_hashTable = {}
    @set key, x for {key, x} in init

  get: (key) =>
    {key} = toKey key
    @_get key

  _get: (key) =>
    @_hashTable[key]?[0]

  _onModification: () =>
    delete @_keysCache

  set: (key, value) =>
    {key} = toKey key
    @_hashTable[key] = [value]
    @_onModification()
    @

  remove: (iterOrKey) =>
    {key, iter} = toKey iterOrKey
    value = @_get key
    delete @_hashTable[key]
    @_onModification()
    if iter? then [value, iter._removed()] else value

  contains: (key) =>
    {key} = toKey key
    @_hashTable[key] isnt undefined

  _keys: () =>
    @_keysCache = Object.keys(@_hashTable) unless @_keysCache?
    @_keysCache

  begin: () =>
    new _Iterator @, @_keys(), -1

  end: () =>
    keys = @_keys()
    new _Iterator @, keys, keys.length

  first: () =>
    @begin().next()

  last: () =>
    @end().prev()

  length: () =>
    @_keys().length

  isEmpty: () =>
    @length() is 0

  toArray: () =>
    foldl @, [], (acc, view) ->
      acc.push view
      acc

  cumulate: ({key, value}) =>
    @set key, value

  replace: (iter, x) =>
    @set iter.key(), x


exports.Map = Map
