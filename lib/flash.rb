require 'json'

class Flash
  attr_reader :now

  def initialize(req)
    @now = req.cookies["_rails_lite_app_flash"] ? JSON.parse(req.cookies["_rails_lite_app_flash"]) : {}
    @flash = {}
  end

  def [](key)
    @now[key.to_s] || @flash[key.to_s] || @now[key]
  end

  def []=(key, val)
    @flash[key.to_s] = val
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', path: '/', value: @flash.to_json)
  end
end
