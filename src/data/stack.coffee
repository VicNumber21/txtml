List = require('data/linked-list').LinkedList


class Stack
  constructor: () ->
    @_list = new List

  push: (val) =>
    @_list.prependValue(val)
    val

  pop: () =>
    [val, _] = @_list.remove @_list.first()
    val

  top: () =>
    @_list.first().value()

  isEmpty: () =>
    @_list.isEmpty()


exports.Stack = Stack
