Dir[File.dirname(__FILE__) + "../views/dogs/*.html.erb"].each {|file| require file }
require_relative '../models/dog'

class DogsController < ControllerBase
  protect_from_forgery

  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
