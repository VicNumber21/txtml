clone = require('data/util').clone


class Type
  simple: 0
  iter: 1
  object: 2

  constructor: (key) ->
    @name = typeof key
    @code = switch @name
              when 'number', 'string'
                @simple
              when 'object'
                if key.prev? and key.next? and key.hash? and key.value? and key.view?
                  @iter
                else if typeof key.hash is 'function'
                  @object


class Hash
  constructor: (@_key) ->
    if @_key?
      @_type = new Type(@_key)
      @_hash = switch @_type.code
                  when Type::simple
                    @_type.name + '_' + @_key
                  when Type::iter
                    @_key.hash()
                  when Type::object
                    simpleHash = @_key.hash()
                    simpleHashType = typeof simpleHash
                    (@_type.name + '_' + simpleHashType + '_' + simpleHash) if simpleHashType in ['number', 'string']

    throw new Error 'Non-hashable value' if @_hash is undefined

  hash: () ->
    @_hash

  key: () ->
    @_key

  keyClone: () ->
    @_keyClone ?= switch @_type.code
                    when Type::simple
                      @_key
                    when Type::iter
                      @_key.key()
                    when Type::object
                      clone @_key
    @_keyClone

  isSimple: () ->
    @_type.code is Type::simple

  isObject: () ->
    @_type.code is Type::object

  isIter: () ->
    @_type.code is Type::iter


module.exports = Hash
