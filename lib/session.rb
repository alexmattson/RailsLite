require 'json'

class Session

  def initialize(req)
    cookie = req.cookie["_rails_lite_app"]
    @info = cookie ? JSON.parse(cookie) : {}
  end

  def [](key)
    @info[key]
  end

  def []=(key, val)
    @info[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
  end
end
