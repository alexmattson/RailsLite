require 'json'

class Flash
  attr_reader :future, :info

  def initialize(req)
    cookie = req.cookies["_rails_lite_app_flash"]
    @info = cookie ? JSON.parse(cookie) : {}
    @future = Hash.new
  end

  def [](key)
    @info[key.to_s] || @future[key]
  end

  def []=(key, val)
    @future[key] = val
    @info[key] = val
  end

  def store_flash(res)
    cookie = { path: '/', value: @future.to_json}
    res.set_cookie("_rails_lite_app_flash", cookie)
  end

  def now
    @info
  end
end
