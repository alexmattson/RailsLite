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
  
end
