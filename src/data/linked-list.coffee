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
    throw Error 'Iterator to dummy node' if @_isDummy()
    @_node.value

  isDone: () =>
    @_started and @_isDummy()

  reverse: () =>
    @_direction = @_direction.flip()
    this

  _isDummy: () =>
    @_owner._dummy is @_node

  validate: () =>
    throw Error 'Invalid node' unless @_node.isValid()
    throw Error 'Iteration finished' if @isDone()


###
  it looks like the approach to insert list object as is is not the best what can be done
  better to insert node chain into target list
  to work correctly with reversed list, some marker should be used in the node to swap prev / next
  pointer usage for this and the following nodes
  Special cases:
    1. insertion of zero-length list should be ignored
    2. insertion of list of length 1 should ignore reverse flag of this list (insert the value of the node)
    3. insertion of list of length 2 may be done with the current state of prev / next usage (flatten on fly)
    4. the rest should follow the common rule
  It could be a headacke with deletion of node. Need to investigate it more
  So better to implement deletion in the current architecture and refactor to the better solution then.
###

class LinkedList
  constructor: (init = []) ->
    @_dummy = new _Node()
    @_reversed = false
    @_lenght = 0
    @appendValue(val) for val in init

  begin: () =>
    @_dummyIter @_direction()

  end: () =>
    @_dummyIter @_direction()

  first: () =>
    @begin().next()

  last: () =>
    @begin().prev()

  isEmpty: () =>
    @_dummy.isSingle()

  length: () =>
    @_lenght

  reverse: () =>
    @_reversed = !@_reversed
    this

  prependValue: (val) =>
    newNode = new _Node val
    @_prepend newNode
    this

  appendValue: (val) =>
    newNode = new _Node val
    @_append newNode
    this

  insertValueBefore: (nodeIter, val) =>
    nodeIter.validate()
    newNode = new _Node val
    @_insertBefore nodeIter, newNode
    this

  insertValueAfter: (nodeIter, val) =>
    nodeIter.validate()
    newNode = new _Node val
    @_insertAfter nodeIter, newNode
    this

  prependList: (list) =>
    @insertListAfter @begin(), list

  appendList: (list) =>
    @insertListBefore @begin(), list

  insertListBefore: (nodeIter, list) =>
    nodeIter.validate()
    @_insertList nodeIter.prev(), list, nodeIter
    this

  insertListAfter: (nodeIter, list) =>
    nodeIter.validate()
    @_insertList nodeIter, list, nodeIter.next()
    this

  remove: (nodeIter) =>
    next = nodeIter.next()
    node = nodeIter._node
    @_remove node
    [node.value, next]


  toArray: () =>
    iter = @begin()
    iter.value() until (iter = iter.next()).isDone()

  _dummyIter: (direction) =>
    new _Iterator this, @_dummy, direction

  _createListIterator: (node, isForward) =>
    iterClass = if @_isListOfListNode node then  _ListOfListIterator else _ListIterator
    new iterClass(this, node, isForward)

  _increaseLength: (x = 1) =>
    @_lenght += x

  _prepend: (newNode) =>
    @_insertAfter @begin(), newNode

  _append: (newNode) =>
    @_insertBefore @begin(), newNode

  _insertBefore: (nextIter, newNode) =>
    @_insert nextIter.prev(), newNode, nextIter

  _insertAfter: (prevIter, newNode) =>
    @_insert prevIter, newNode, prevIter.next()

  _insert: (prevIter, newNode, nextIter) =>
    d = prevIter._direction
    newNode.clearFlips()
    @_setPrev prevIter, d, newNode
    @_setNext nextIter, d, newNode
    @_increaseLength()

  _insertList: (prevIter, list, nextIter) =>
    l = list.length()
    switch
      when l is 1
        @_insert prevIter, list.first()._node, nextIter
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

  _direction: () =>
    if @_reversed then _Direction::backward() else _Direction::forward()

  _remove: (node) =>
    d = @_direction()
    [prev, prevD] = node.prev(d)
    [next, nextD] = node.next(d)
    flip = prevD isnt nextD
    prev.setNext prevD, next, flip
    next.setPrev nextD, prev, flip
    --@_lenght


exports.LinkedList = LinkedList
