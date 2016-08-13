Dir[File.dirname(__FILE__) + "../views/dogs/*.html.erb"].each {|file| require file }
require_relative '../models/dog'

class DogsController < ControllerBase
  protect_from_forgery

  def create
    @dog = Dog.new(params["dog"])
    if @dog.valid?
      @dog.save
      flash[:notice] = "Saved dog successfully"
      redirect_to "/dogs"
    else
      flash.now[:errors] = @dog.errors
      render :new
    end
  end

  def index
    @dogs = Dog.all
    render :index
  end

  def new
    @dog = Dog.new
    render :new
  end

  def show
    @dog = Dog.find(params["id"])
  end
end
