_new = require('data/util').new
clone = require('data/util').clone

_iterate = (iter, acc0, viewModifier, f) ->
  ctrl = stop: false, acc: acc0, iter: iter
  ctrl.acc = f viewModifier(ctrl.iter.view()), ctrl until ctrl.stop or (ctrl.iter = ctrl.iter.next()).isDone()
  ctrl.acc


class Base
  constructor: (safeView) ->
    @_viewModifier = if safeView then clone else (x) -> x

  from: (@_s, reversed) =>
    @_begin = if reversed then @_s.end().reverse() else @_s.begin()
    @


class ForEachBase extends Base
  constructor: (safeView) ->
    super safeView
    @_p = () -> true

  if: (@_p) =>
    @

  reduce: (a0, f) =>
    throw new Error 'Sequence is not defined' unless @_begin?

    _iterate @_begin, a0, @_viewModifier, (view, {acc}) =>
      if @_p view
        f acc, view
      else
        acc

  do: (f) =>
    @reduce undefined, (a, view) =>
      f view

  filter: (p) =>
    @if(p).map ({x}) -> x


class ForEachCopy extends ForEachBase
  to: (@_acc) =>
    @

  _getAcc: () =>
    @_acc ?= _new @_s

  map: (f = ({x}) -> x) =>
    @reduce @_getAcc(), (a, view) =>
      a.cumulate f(view), view


class ForEachReplace extends ForEachBase
  map: (f) =>
    iter = @_s.first()

    until iter.isDone()
      view = iter.view()

      if @_p view
        @_s.replace iter, f view
        iter = iter.next()
      else
        [_, iter] = @_s.remove iter

    @_s


class Any extends Base
  is: (p) =>
    _iterate @_begin, false, @_viewModifier, (view, ctrl) =>
      ctrl.stop = p view


class Each extends Any
  is: (p) =>
    if @_s.isEmpty()
      false
    else
      not super (view) =>
        not p view


class Interface
  constructor: (@_iterationClass, @_safeView) ->

  from: (s) =>
    iteration = new @_iterationClass @_safeView
    iteration.from(s, false)

  fromReversed: (s) =>
    iteration = new @_iterationClass
    iteration.from(s, true)


class Iteration
  constructor: (ForEachClass) ->
    @forEach = new Interface ForEachClass
    @ifEach = new Interface Each
    @ifAny = new Interface Any


exports.Copy =
  forEach: new Interface ForEachCopy, true
  ifEach: new Interface Each, true
  ifAny: new Interface Any, true


exports.Replace =
  forEach: new Interface ForEachReplace, false
  ifEach: new Interface Each, false
  ifAny: new Interface Any, false
