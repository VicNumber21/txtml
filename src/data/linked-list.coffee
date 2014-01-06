class _Direction
  _k_backward: 0
  _k_forward: 1

  constructor: (@_d) ->

  forward: () ->
    _Direction::_forward = new _Direction @_k_forward if not _Direction::_forward?
    _Direction::_forward

  backward: () ->
    _Direction::_backward = new _Direction @_k_backward if not _Direction::_backward?
    _Direction::_backward

  flip: () =>
    if @isForward() then @backward() else @forward()

  prevIdx: () =>
    @flip()._d

  nextIdx: () =>
    @_d

  isForward: () =>
    @_d is @_k_forward

  isBackward: () =>
    @_d is @_k_backward


class _Node
  constructor: (@value = null) ->
    selfLink = @_link @
    @_links = [selfLink, selfLink]

  _link: (node, flip = false) ->
    node: node, flip: flip

  _unlink: (d, idx) =>
    link = @_links[idx]
    d = d.flip() if link.flip
    [link.node, d]

  prev: (d) =>
    @_unlink d, d.prevIdx()

  setPrev: (d, node, flip = false) =>
    @_links[d.prevIdx()] = @_link node, flip

  next: (d) =>
    @_unlink d, d.nextIdx()

  setNext: (d, node, flip = false) =>
    @_links[d.nextIdx()] = @_link node, flip

  clearFlips: () =>
    link.flip = false for link in @_links

  isValid: () =>
    d = _Direction::forward()
    [prev , dPrev] = @prev(d)
    [prevNext, _] = prev.next(dPrev)
    [next, dNext] = @next(d)
    [nextPrev, _] = next.prev(dNext)
    (@ is prevNext) and (@ is nextPrev)

  isSingle: () =>
    @ is @_links[0].node and @ is @_links[1].node


class _Iterator
  constructor: (@_owner, @_node, @_direction, @_started = not @_isDummy()) ->

  prev: () =>
    @validate()
    [prev, d] = @_node.prev(@_direction)
    new _Iterator @_owner, prev, d, true

  next: () =>
    @validate()
    [next, d] = @_node.next(@_direction)
    new _Iterator @_owner, next, d, true

  value: () =>
    @validate()
    throw Error 'Dummy node iterator' if @_isDummy()
    @_node.value

  view: () =>
    {x: @value()}

  reverse: () =>
    new _Iterator @_owner, @_node, @_direction.flip(), @_started

  isDone: () =>
    @_started and @_isDummy()

  validate: () =>
    throw Error 'Invalid node' unless @_node.isValid()
    throw Error 'Iteration finished' if @isDone()

  _isDummy: () =>
    @_owner._dummy is @_node


class LinkedList
  constructor: (init = []) ->
    @_dummy = new _Node()
    @_direction = _Direction::forward()
    @_lenght = 0
    @append(val) for val in init

  begin: () =>
    @_dummyIter @_direction

  end: () =>
    @_dummyIter @_direction

  first: () =>
    @begin().next()

  last: () =>
    @end().prev()

  isEmpty: () =>
    @_dummy.isSingle()

  length: () =>
    @_lenght

  reverse: () =>
    @_direction = @_direction.flip()
    @

  prepend: (val) =>
    @_insertAfter @begin(), val
    @

  append: (val) =>
    @_insertBefore @end(), val
    @

  cumulate: ({x}) =>
    @append x

  insertBefore: (iter, val) =>
    @_insertBefore iter, val
    @

  insertAfter: (iter, val) =>
    @_insertAfter iter, val
    @

  prependList: (list) =>
    @insertListAfter @begin(), list

  appendList: (list) =>
    @insertListBefore @end(), list

  insertListBefore: (iter, list) =>
    @_insertList iter.prev(), list, iter
    @

  insertListAfter: (iter, list) =>
    @_insertList iter, list, iter.next()
    @

  replace: (iter, newValue) =>
    oldValue = iter.value()
    iter._node.value = newValue
    oldValue

  remove: (iter) =>
    next = iter.next()
    node = iter._node
    @_remove node
    [node.value, next]

  toArray: () =>
    iter = @begin()
    iter.value() until (iter = iter.next()).isDone()

  _dummyIter: (direction) =>
    new _Iterator @, @_dummy, direction

  _increaseLength: (x = 1) =>
    @_lenght += x

  _insertBefore: (nextIter, val) =>
    @_insert nextIter.prev(), val, nextIter

  _insertAfter: (prevIter, val) =>
    @_insert prevIter, val, prevIter.next()

  _insert: (prevIter, val, nextIter) =>
    newNode = new _Node val
    d = prevIter._direction
    newNode.clearFlips()
    @_setPrev prevIter, d, newNode
    @_setNext nextIter, d, newNode
    @_increaseLength()

  _insertList: (prevIter, list, nextIter) =>
    l = list.length()
    switch
      when l is 1
        @_insert prevIter, list.first().value(), nextIter
      when l > 1
        first = list.first()
        last = list.last()
        firstNode = first._node
        lastNode = last._node
        @_setPrev prevIter, first._direction, firstNode
        @_setNext nextIter, last._direction, lastNode
        @_increaseLength l

  _setPrev: (prevIter, d, newNode) =>
    prev = prevIter._node
    flip = prevIter._direction isnt d
    newNode.setPrev d, prev, flip
    prev.setNext prevIter._direction, newNode, flip

  _setNext: (nextIter, d, newNode) =>
    next = nextIter._node
    flip = nextIter._direction isnt d
    newNode.setNext d, next, flip
    next.setPrev nextIter._direction, newNode, flip

  _remove: (node) =>
    d = @_direction
    [prev, prevD] = node.prev(d)
    [next, nextD] = node.next(d)
    flip = prevD isnt nextD
    prev.setNext prevD, next, flip
    next.setPrev nextD, prev, flip
    --@_lenght


exports.LinkedList = LinkedList
