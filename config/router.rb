require_relative '../rails/router'
Dir[File.dirname(__FILE__) + "/../lib/controllers/*.rb"].each {|file| require file }

@router = Router.new
@router.draw do

  # To create routes, use the following structure:
  # HTTP_METHOD PATTERN, CONTROLLER_CLASS, ACTION_NAME
  #
  # Here is an example route group:
  #
  # get Regexp.new("^/users$"), UsersController, :index
  # get Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :show
  # get Regexp.new("^/users/new$"), UsersController, :new
  # post Regexp.new("^/users$"), UsersController, :create
  # get Regexp.new("^/users/(?<id>\\d+)/edit$"), UsersController, :edit
  # patch Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :update
  # put Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :update
  # delete Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :destroy

  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/dogs/(?<id>\\d+)$"), DogsController, :show
  get Regexp.new("^/dogs/new$"), DogsController, :new
  post Regexp.new("^/dogs$"), DogsController, :create
  get Regexp.new("^/dogs/(?<id>\\d+)/edit$"), DogsController, :edit
  patch Regexp.new("^/dogs/(?<id>\\d+)$"), DogsController, :update
  delete Regexp.new("^/dogs/(?<id>\\d+)$"), DogsController, :destroy


  #for error demenstration
  get Regexp.new("^/raise$"), DogsController, :critical
end
