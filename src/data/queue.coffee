List = require 'data/list'


class Queue
  constructor: () ->
    @_list = new List

  enqueue: (val) =>
    @_list.prepend(val)
    val

  dequeue: () =>
    [val, _] = @_list.remove @_list.last()
    val

  peek: () =>
    @_list.last().value()

  length: () =>
    @_list.length()

  isEmpty: () =>
    @_list.isEmpty()


module.exports = Queue
