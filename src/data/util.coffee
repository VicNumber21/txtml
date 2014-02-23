_new = (s) ->
  proto = Object.getPrototypeOf s
  new proto.constructor

clone = (s) ->
  c = _new s
  for key of s when s.hasOwnProperty(key)
    p = s[key]
    type = typeof p
    c[key] = switch type
               when 'object'
                 if p instanceof Date
                   new Date p.getTime()
                 else if p instanceof RegExp
                   new RegExp p
                 else if p.cloneNode?
                   p.cloneNode true
                 else
                   clone(p)
               when 'array'
                 clone x for x in p
               else
                 p
  c


exports.new = _new
exports.clone = clone
