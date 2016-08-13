require_relative 'app_rack_dependencies.rb'

DBConnection.reset

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  @router.run(req, res)
  res.finish
end

rack = Rack::Builder.new do
  # use ShowExceptions
  use Static
  run app
end.to_app

Rack::Server.start(
 app: rack,
 Port: 3000
)
