

Summary:
--------
RailsLite is a project dedicated to fully understanding the construction of the rails framework.

It is a _very_ stripped down version of Ruby on Rails that is integrated with my custom [ActiveRecordLite project](http://github.com/amattson21/ActiveRecordLite).

[![railslite.jpg](https://s4.postimg.org/514g1lo0d/railslite.jpg)](//github.com/amattson21/RailsLite/)


Demo:
-----

1. [Click here](https://github.com/amattson21/RailsLite/blob/master/rails/assets/DogsLite.zip) to download sample RailsList project
2. run ``$ ruby on_rails_lite`` to launch app on localhost:3000
3. Create/Edit/Delete Dogs on the sample site
4. visit '/raise' to see simple custom built error handling middleware that is based on the style of the "Better Errors" gem.
5. If you would like to create a custom app on this platform to test its functionality, please refer to the usage docs below.


Usage:
------

### Getting Started with a New App ###


First things first, you will need to clone this repository.

Rename the file to your desired app name and you're all ready to get started.

Here is a quick outine of the file strcture:

```
+-- config 						// ORM, Rack, Middleware and Router
|	+--active_record_lite
|	|	...
|	+--app_rack
|	|	+--middleware
|	|	|	...
|	|	...
|	+--router.rb
+--db							// database
|	+--database.sql
|	+--database.db* 			*file is added after initial run
+--lib							// application files
|	+--assets
|	|	...
|	+--controllers
|	|	...
|	+--models
|	|	...
|	+--views
|	|	...
+--rails 						//rails lite specific files
|	...
+--Gemfile
...


```


### Creating a Model ###

Duplicate the ``model.rb`` file that we currently have in the lib/models folder and rename to your desired model name. Ensure singularity of the model name.

```ruby
class Model < SQLObject
  my_attr_accessor

  def initialize(params = {})
    params ||= {}
    super(params)
  end

  def errors
    @errors ||= []
  end

  def valid?
  end

  finalize!
end
```

First thing to go over is the name change to ``my_attr_accessor``, although functionally the same as a standard rails ``attr_accessor``.

Next is the way that params must be past in. You must pass params in as a hash as indicated in our intialization function. This also means setting instance variables in the following way ``@sample = params["sample"]``

Finally, validations can be written in the ``valid?`` method. Any custom errors that you wish to raise within can be pushed into your errors array allowing you to call ``Model.errors`` to propigate flash. Here is a sample presence validation method:

```ruby
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
```
### Adding to the Database ###

To add a database table for your model just hade over to the ``database.sql`` file and add the tble there through sql commands.

```sql
CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner VARCHAR(255) NOT NULL
);
```
You will need to reset the database to add the table. To accomplish this, simply run ``ruby reset_database``.

Feel free to add any seed data to the this file aswell.


### Creating Routes ###

To create routes, use the following structure:
```
HTTP_METHOD PATTERN, CONTROLLER_CLASS, ACTION_NAME
```  
  You can define all patterns in regex.

  Here is an example route group:
```ruby  
  get Regexp.new("^/users$"), UsersController, :index
  get Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :show
  get Regexp.new("^/users/new$"), UsersController, :new
  post Regexp.new("^/users$"), UsersController, :create
  get Regexp.new("^/users/(?<id>\\d+)/edit"), UsersController, :edit
  patch Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :update
  put Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :update
  delete Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :destroy
```

### Creating a Controller ###

You can duplicate the ``controller.rb`` file that we currently have in the ``lib/controllers`` folder and rename to your desired controller name. It is important that this is a plural version of your model name followed by an '_controller.rb'.

i.e. if you have a ``dog.rb`` controller you will need a `dogs_controller.rb`.

Also be sure to rename the class name to your chosen controller name.

```ruby
...
class DogsController < ControllerBase
...
```

In your create or update methods be sure to structure your if statments around the ``valid?`` method since that is where the actual checks will take place. For example:

```ruby
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
```

At the top of each class ``protect_from_forgery`` has been implimented to protect again CSRF attacks. Ensure that all forms include an authentication token.
```html
<input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
```
### Creating Views ###

Nothing has changed with views in comparision to the original rails. Same plural model name structure for the file and file names matching controller method names.

The ``application.html.erb`` resides in the layout folder in the views.

### Assets ###

Add any css you wish to the application.css file in the ``lib/assets/stylesheets``

### Done ###

That should be enough to get everything up and running!

---
Developed by [Alex Mattson](http://www.alexmattson.com)
