_new = (s) ->
  proto = Object.getPrototypeOf s
  new proto.constructor

clone = (s) ->
  t = _new s
  t[key] = s[key] for key of s when s.hasOwnProperty(key)
  t


exports.new = _new
exports.clone = clone
