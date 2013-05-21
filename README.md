# Cleartape

Cleartape provides an alternative to [ActiveRecord::NestedAttributes#accepts_nested_attributes_for](http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html#method-i-accepts_nested_attributes_for) in the form of, well, a Form! It is heavily inspired by ["redtape"](https://github.com/ClearFit/redtape) gem which in turn was inspired by ["7 Ways to Decompose Fat Activerecord Models"](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/) by [Bryan Helmkamp](https://github.com/brynary).

In a nutshell, `accepts_nested_attributes_for` tightly couples your View to your Model. This is highly undesirable as it makes both harder to maintain. Instead, the Form mediates between the two, acting like an ActiveModel from the View and Controller's perspective but acting a proxy to the model layer.

## Features

* Flexibility - you handle mapping of form data into ActiveRecord objects
* Infers validations from ActiveRecord objects or define them independently
* Conditional validations make multistep forms easy without complicating model layer
* Plays nicely with client_side_validations gem

## Missing features

* Direct support for nested attributes - at present nesting needs to be handled explicitly

## Installation

Add this line to your application's Gemfile:

    gem 'cleartape'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cleartape

## Usage

To use Cleartape, you use a *Cleartape::Form* subclass in your controller and your nested *form_for*s where you would
supply an ActiveRecord object.

A *Cleartape::Form* is simply an ActiveModel.  So you just call *#save*, *#valid?*, and *#errors* on it like any other ActiveModel.

Cleartape can use your model's/models' validations to determine if the form data is correct. That is, you validate and save the same way you would with any ActiveRecord. If any of the models are invalid, errors are added to the Form for handling within the View/Controller.

Using a *Cleartape::Form* for a multistep form goes like this...

The models:

```ruby
class User < ActiveRecord::Base
  has_many :gizmos

  validates :email, :presence => true, :uniqueness => true
  validates :phone, :presence => true
  validates :sex,   :inclusion => { :in => ["male", "female", "other"] }
  validates :age,   :presence => true,
                    :numericality => { :only_integer => true, :greater_than => 0 }
end

class Gizmo < ActiveRecord::Base
  belongs_to :user

  validates :user, :presence => true
  validates :name, :presence => true
  validates :description, :length => { :maximum => 200 }
end
```

The form itself:

```ruby
class UserForm < Cleartape::Form

  models :user

  step :basics do |s|
    s.apply_validations :user, :email, :phone, :uniqueness => false 
  end

  step :details do |s|
    s.apply_validations :user, :sex, :age
  end

  step :gizmo do |s|
    s.apply_validations :gizmo, :name
    s.validates :user, :description, :presence => true, :length => { :minimum => 50, :maximum => 200 }
  end

  private

  # This is where you put your logic, that is anything you want to do with
  # collected user input, i.e. associate and persist your models.
  #
  # Cleartape calls +process+ from +save+ if validations pass. Then advances
  # to next step.
  #
  def process
    return unless last_step?

    @user = User.create!(attributes[:user])
    @gizmo = Gizmo.create!(attributes[:gizmo].merge(:user => @user))
  end

end
```

The controller:

```ruby
class UsersController
  def new
    @form = UserForm.new(self, params)
  end

  def create
    @form = UserForm.new(self, params)
    if @form.save && @form.last_step?
      flash[:notice] = "Hurrah!"
      redirect_to user_url(@form.user)
    else
      render
    end
  end
end
```

The views for subsequent steps:

```haml
= form_for @form do |form|
  -# preserves user input between steps and tracks current step
  = form.hidden_field :persistence_token

  = form.fields_for :user do |fields|
    = fields.text_field :email
    = fields.text_field :phone
  
  = form.submit
```

```haml
= form_for @form do |form|
  = form.hidden_field :persistence_token

  = form.fields_for :user do |fields|
    = fields.select :sex, %w[male female other]
    = fields.text_field :age

  = form.submit
```

```haml
= form_for @form do |form|
  = form.hidden_field :persistence_token

  = form.fields_for :gizmo do |fields|
    = fields.text_field :name
    = fields.text_area :description

  = form.submit
```

## What's left

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Finally, we'd really like your feedback


