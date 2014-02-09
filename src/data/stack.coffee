List = require 'data/list'


class Stack
  constructor: () ->
    @_list = new List

  push: (val) =>
    @_list.prepend(val)
    val

  pop: () =>
    [val, _] = @_list.remove @_list.first()
    val

  top: () =>
    @_list.first().value()

  length: () =>
    @_list.length()

  isEmpty: () =>
    @_list.isEmpty()


module.exports = Stack
