class _ListNode
  constructor: (@_value = null) ->
    @_prev = @
    @_next = @

  isValid: () =>
    (this is this._prev._next) and (this is this._next._prev)


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

class _ListOfListNode extends _ListNode
  constructor: (_value, @_reverseFlag) ->
    throw Error 'Reverse flag must be set and be boolean' if typeof @_reverseFlag isnt 'boolean'
    super _value


class _ListIterator
  constructor: (@_owner, @_current) ->

  prev: () =>
    @_owner._prev @_current

  next: () =>
    @_owner._next @_current

  value: () =>
    @_current._value

  isDone: () =>
    @_owner._dummy is @_current

  validate: () =>
    throw Error 'Invalid iterator' unless @_current.isValid()


class _ListOfListIterator extends _ListIterator
  constructor: (owner, current, isForward = true) ->
    super owner, current
    list = current._value
    list.reverse() if @_isReverseModified()
    @_iter = if isForward then list.first() else list.last();

  _isReverseModified: () =>
    @_owner._reversed isnt (@_current._value._reversed isnt @_current._reverseFlag)

  prev: () =>
    @_iter = @_iter.prev()
    if @_iter.isDone() then super() else this

  next: () =>
    @_iter = @_iter.next()
    if @_iter.isDone() then super() else this

  value: () =>
    @_iter.value()


class LinkedList
  constructor: (init = []) ->
    @_dummy = new _ListNode()
    @_reversed = false
    @_lenght = 0
    @appendValue(val) for val in init

  begin: () =>
    @_dummyIter()

  end: () =>
    @_dummyIter()

  first: () =>
    @_dummyIter().next()

  last: () =>
    @_dummyIter().prev()

  isEmpty: () =>
    @_dummy._prev is @_dummy and @_dummy._next is @_dummy

  length: () =>
    @_lenght

  reverse: () =>
    @_reversed = !@_reversed
    this

  prependValue: (val) =>
    newNode = new _ListNode val
    @_prepend newNode
    @_increaseLength()
    this

  appendValue: (val) =>
    newNode = new _ListNode val
    @_append newNode
    @_increaseLength()
    this

  insertValueBefore: (nodeIter, val) =>
    nodeIter.validate()
    node = nodeIter._current

    if @_isListOfListNode node
      node._value.insertValueBefore nodeIter._iter, val
    else
      newNode = new _ListNode val

      if @_reversed
        @_insertAfter node, newNode
      else
        @_insertBefore node, newNode

    @_increaseLength()
    this

  insertValueAfter: (nodeIter, val) =>
    nodeIter.validate()
    node = nodeIter._current

    if @_isListOfListNode node
      node._value.insertValueAfter nodeIter._iter, val
    else
      newNode = new _ListNode val

      if @_reversed
        @_insertBefore node, newNode
      else
        @_insertAfter node, newNode

    @_increaseLength()
    this

  prependList: (list) =>
    newNode = @_createListNode list

    if newNode?
      @_prepend newNode
      @_increaseLength list.length()

    this

  appendList: (list) =>
    newNode = @_createListNode list

    if newNode?
      @_append newNode
      @_increaseLength list.length()

    this

  insertListBefore: (nodeIter, list) =>
    nodeIter.validate()
    node = nodeIter._current

    if @_isListOfListNode node
      node._value.insertListBefore nodeIter._iter, list
    else
      newNode = @_createListNode list

      if newNode?
        if @_reversed
          @_insertAfter node, newNode
        else
          @_insertBefore node, newNode

    @_increaseLength list.length()
    this

  insertListAfter: (nodeIter, list) =>
    nodeIter.validate()
    node = nodeIter._current

    if @_isListOfListNode node
      node._value.insertListAfter nodeIter._iter, list
    else
      newNode = @_createListNode list

      if newNode?
        if @_reversed
          @_insertBefore node, newNode
        else
          @_insertAfter node, newNode

    @_increaseLength list.length()
    this

  remove: (nodeIter) =>
    node = nodeIter._current

    if node.isValid() and node isnt @_dummy
      doRemoveNode = not isListOfListNode = @_isListOfListNode node

      if isListOfListNode
        internalList = node._value
        internalList.remove nodeIter._iter
        doRemoveNode = internalList.length() is 0

      @_remove node if doRemoveNode
      --@_lenght

    this

  toArray: () =>
    iter = @begin()
    iter.value() until (iter = iter.next()).isDone()

  _dummyIter: () =>
    new _ListIterator this, @_dummy

  _createListNode: (list) =>
    switch list.length()
      when 0 then undefined
      when 1 then new _ListNode list.first().value()
      else new _ListOfListNode(list, @_reversed isnt list._reversed)

  _prev: (current) =>
    node = if @_reversed then current._next else current._prev
    @_createListIterator node, false

  _next: (current) =>
    node = if @_reversed then current._prev else current._next
    @_createListIterator node, true

  _createListIterator: (node, isForward) =>
    iterClass = if @_isListOfListNode node then  _ListOfListIterator else _ListIterator
    new iterClass(this, node, isForward)

  _isListOfListNode: (node) =>
    node._reverseFlag?

  _increaseLength: (x = 1) =>
    @_lenght += x

  _prepend: (newNode) =>
    insert = if @_reversed then @_insertBefore else @_insertAfter
    insert @_dummy, newNode

  _append: (newNode) =>
    insert = if @_reversed then @_insertAfter else @_insertBefore
    insert @_dummy, newNode

  _insertBefore: (node, newNode) =>
    newNode._prev = node._prev
    newNode._next = node
    newNode._prev._next = newNode
    node._prev = newNode

  _insertAfter: (node, newNode) =>
    newNode._prev = node
    newNode._next = node._next
    newNode._next._prev = newNode
    node._next = newNode

  _remove: (node) =>
    node._prev._next = node._next
    node._next._prev = node._prev


exports.LinkedList = LinkedList
