_iterate = (iter, acc0, f) ->
  ctrl = stop: false, acc: acc0, iter: iter
  ctrl.acc = f ctrl.iter.value(), ctrl until ctrl.stop or (ctrl.iter = ctrl.iter.next()).isDone()
  ctrl.acc

_new = (s) ->
  proto = Object.getPrototypeOf s
  new proto.constructor


class CopyIteration
  @foldl = (s, a0, f) ->
    _iterate s.begin(), a0, (x, {acc}) ->
      f acc, x

  @foldr: (s, a0, f) ->
    _iterate s.end().reverse(), a0, (x, {acc}) ->
      f x, acc

  @map: (s, f) ->
    CopyIteration.foldl s, _new(s), (a, x) ->
      a.append f x

  @rmap: (s, f) ->
    CopyIteration.foldr s, _new(s), (x, a) ->
      a.append f x

  @forEach: (s, f) ->
    CopyIteration.foldl s, undefined, (a, x) ->
      f x

    undefined

  @filter: (s, p) ->
    CopyIteration.foldl s, _new(s), (a, x) ->
      if p x then a.append x else a

  @any: (s, p) ->
    _iterate s.begin(), false, (x, ctrl) ->
      ctrl.stop = p x

  @all: (s, p) ->
    if s.isEmpty()
      false
    else
      not CopyIteration.any s, (x) ->
        not p x


class ReplaceIteration extends CopyIteration
  @map: (s, f) ->
    _iterate s.begin(), undefined, (x, {iter}) ->
      s.replace iter, f x

    s

  @filter: (s, p) ->
    iter = s.first()

    until iter.isDone()
      if p iter.value()
        iter = iter.next()
      else
        [_, iter] = s.remove iter

    s


exports.Copy = CopyIteration
exports.Replace = ReplaceIteration
