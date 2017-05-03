require 'json'

class Session
  def initialize(req)
    @session_cookie = req.cookies["_rails_lite_app"] ? JSON.parse(req.cookies["_rails_lite_app"]) : {}
  end

  def [](key)
    @session_cookie[key]
  end

  def []=(key, val)
    @session_cookie[key] = val
  end

  def store_session(res)
    res.set_cookie('_rails_lite_app', path: '/', value: @session_cookie.to_json)
  end
end
