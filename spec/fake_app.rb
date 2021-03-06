require 'active_record'
require 'action_controller/railtie'
require 'action_view/railtie'

ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('test')

app = Class.new(Rails::Application)
app.config.active_support.deprecation = :log
app.config.secret_key_base = '15314f4ae1fb4cb0a2871cb8f9c71fb3ef18edeb0488913656c87197e27c9ab014009ddef85e5420e8973d2972f9ec5a1449137b63d0c35511182faee29d12ce'
app.config.eager_load = false
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
