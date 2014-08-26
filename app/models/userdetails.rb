class Userdetails
  include Mongoid::Document
  field :username, type: String
  field :password, type: String
  field :name, type: String
  field :email, type: String
  paginates_per 4
  max_paginates_per 4
end
