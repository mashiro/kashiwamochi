# kashiwamochi

[![Build Status](https://secure.travis-ci.org/mashiro/kashiwamochi.png)](http://travis-ci.org/mashiro/kashiwamochi)

Kashiwamochi is a minimal searching extension for Rails 3.

## Installation

```ruby
gem 'kashiwamochi'
# gem 'kashiwamochi', :git => 'git://github.com/mashiro/kashiwamochi.git'
```

## Getting started

### In your controllers

```ruby
# use before_filter.
before_filter :build_query!, :only => [:index]

# or write directly.
def index
  @q = Kashiwamochi.build(params[:q])
  @users = User.where(:name => @q.name)
end

```

### In your views

```ruby
# _search.html.haml
= search_form_for @q do |f|
  = f.text_field :name
  = f.submit

# _list.html.haml
%table
  %thead
    %tr
      %th= sort_link_to @q, :name, 'User name'
  %tbody
    ...
```

#### With simple_form

```ruby
= search_form_for @q, :form_method => :simple_form_for do |f|
  = f.input :name
  = f.button :submit
```

### CSS

```css
// Show the sort direction.
.sort_link {
    &.asc:after {
      content: " \25b2";
    }   
    &.desc:after {
      content: " \25bc";
    }   
}
```

## Copyright

Copyright (c) 2011 mashiro

