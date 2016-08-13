require 'json'

class Session

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

  def store_session(res)
    cookie = { path: '/', value: @info.to_json}
    res.set_cookie("_rails_lite_app", cookie)
  end
end
