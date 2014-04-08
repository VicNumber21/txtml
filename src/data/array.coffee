forEach = require('data/iteration').Copy.forEach


class _Iterator
  constructor: (@_owner, @_idx, @_step = 1) ->

  prev: () =>
    new _Iterator @_owner, @_idx - @_step, @_step

  next: () =>
    new _Iterator @_owner, @_idx + @_step, @_step

  isDone: () =>
    if @_step > 0
      @_idx >= @_owner.length
    else
      @_idx < 0

  value: () =>
    @_owner[@_idx]

  view: () =>
    {idx: @_idx, x: @_owner[@_idx]}

  reverse: () =>
    new _Iterator @_owner, @_idx , -@_step


Array::begin = () ->
  new _Iterator @, -1

Array::end = () ->
  new _Iterator @, @length

Array::first = () ->
  @begin().next()

Array::last = () ->
  @end().prev()

Array::cumulate = (x) ->
  @push x
  @

Array::replace = (iter, x) ->
  old = iter.value()
  @[iter._idx] = x
  old

Array::remove = (iter) ->
  old = iter.value()
  @.splice iter._idx, 1
  [old, iter]

Array::isEmpty = () ->
  @length is 0

Array::fromSequenceView = (seq) =>
  forEach.from(seq).to([]).map (view) ->
    view

Array::fromSequenceValue = (seq) =>
  forEach.from(seq).to([]).map()
