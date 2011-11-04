require 'active_record'
require 'action_controller/railtie'
require 'action_view/railtie'

ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('test')

app = Class.new(Rails::Application)
app.config.active_support.deprecation = :log
app.initialize!

app.routes.draw do
  resources :users
end

class User < ActiveRecord::Base
  has_many :statuses
end

class CreateTestTables < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.integer :age
    end
  end
end
