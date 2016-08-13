require 'json'

class Flash
  attr_reader :future, :info

  def initialize(req)
    cookie = req.cookies["_rails_lite_app_flash"]
    @info = FlashStore.new(cookie ? JSON.parse(cookie) : {})
    @future = Hash.new
  end

  def [](key)
    @info[key.to_s]
  end

  def []=(key, val)
    @future[key.to_s] = val
  end

  def store_flash(res)
    cookie = { path: '/', value: @future.to_json}
    res.set_cookie("_rails_lite_app_flash", cookie)
  end

  def now
    @info
  end
end

class FlashStore
  def initialize(store = {})
    @store = store
  end

  def [](key)
    @store[key.to_s]
  end

  def []=(key, val)
    @store[key.to_s] = val
  end

  def to_json
    @store.to_json
  end
end
