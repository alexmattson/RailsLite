require_relative '../rails/router'
Dir[File.dirname(__FILE__) + "/../lib/controllers/*.rb"].each {|file| require file }

@router = Router.new
@router.draw do

  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/dogs/new$"), DogsController, :new
  get Regexp.new("^/dogs/(?<id>\\d+)$"), DogsController, :show
  post Regexp.new("^/dogs$"), DogsController, :create

end
