class Dog < SQLObject
  my_attr_accessor :name, :owner

  def initialize(params = {})
    params ||= {}
    @name, @owner = params["name"], params["owner"]
    super(params)
  end

  def errors
    @errors ||= []
  end

  def valid?
    valid = true
    if @owner == ""
      errors << "Owner can't be blank"
      valid = false
    end

    if @name == ""
      errors << "Name can't be blank"
      valid = false
    end
    valid
  end

  def inspect
    { name: name, owner: owner }.inspect
  end

  finalize!
end
