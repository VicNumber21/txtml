class CopyIteration
  @foldl = (s, a0, f) ->
    iter = s.begin()
    a = a0
    a = f a, iter.value() until (iter = iter.next()).isDone()
    a

  @foldr: (s, a0, f) ->
    iter = s.end()
    a = a0
    a = f iter.value(), a until (iter = iter.prev()).isDone()
    a

  @map: (s, f) ->
    proto = Object.getPrototypeOf(s)

    CopyIteration.foldl s, new proto.constructor, (a, x) ->
      a.append f x

  @rmap: (s, f) ->
    proto = Object.getPrototypeOf(s)

    CopyIteration.foldr s, new proto.constructor, (x, a) ->
      a.append f x

  @forEach: (s, f) ->
    CopyIteration.foldl s, undefined, (a, x) ->
      f x

  @filter: (s, p) ->
    proto = Object.getPrototypeOf(s)

    CopyIteration.foldl s, new proto.constructor, (a, x) ->
      if p x then a.append x else a

  @any: (s, p) ->
    iter = s.begin()
    found = false
    found = p iter.value() until found or (iter = iter.next()).isDone()
    found

  @all: (s, p) ->
    if s.isEmpty()
      false
    else
      not CopyIteration.any s, (x) ->
        not p x


class ReplaceIteration extends CopyIteration
  @map: (s, f) ->
    iter = s.begin()
    s.replace iter, f iter.value() until (iter = iter.next()).isDone()
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
