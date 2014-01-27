_new = require('data/util').new

_iterate = (iter, acc0, f) ->
  ctrl = stop: false, acc: acc0, iter: iter
  ctrl.acc = f ctrl.iter.view(), ctrl until ctrl.stop or (ctrl.iter = ctrl.iter.next()).isDone()
  ctrl.acc


class CopyIteration
  @foldl = (s, a0, f) ->
    _iterate s.begin(), a0, (view, {acc}) ->
      f acc, view

  @foldr: (s, a0, f) ->
    _iterate s.end().reverse(), a0, (view, {acc}) ->
      f view, acc

  @map: (s, f) ->
    CopyIteration.foldl s, _new(s), (a, view) ->
      view.x = f view
      a.cumulate view

  @rmap: (s, f) ->
    CopyIteration.foldr s, _new(s), (view, a) ->
      view.x = f view
      a.cumulate view

  @forEach: (s, f) ->
    CopyIteration.foldl s, undefined, (a, view) ->
      f view

    undefined

  @filter: (s, p) ->
    CopyIteration.foldl s, _new(s), (a, view) ->
      if p view then a.cumulate view else a

  @any: (s, p) ->
    _iterate s.begin(), false, (view, ctrl) ->
      ctrl.stop = p view

  @all: (s, p) ->
    if s.isEmpty()
      false
    else
      not CopyIteration.any s, (view) ->
        not p view


class ReplaceIteration extends CopyIteration
  @map: (s, f) ->
    _iterate s.begin(), undefined, (view, {iter}) ->
      s.replace iter, f view

    s

  @filter: (s, p) ->
    iter = s.first()

    until iter.isDone()
      if p iter.view()
        iter = iter.next()
      else
        [_, iter] = s.remove iter

    s


exports.Copy = CopyIteration
exports.Replace = ReplaceIteration
