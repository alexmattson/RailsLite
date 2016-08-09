require 'json'

class Flash

  def initialize(req)
    cookie = req.cookies["_rails_lite_app"]
    @info = cookie ? JSON.parse(cookie) : {}
  end

  def [](key)
    @info[key]
  end

  def []=(key, val)
    @info[key] = val
  end
end
