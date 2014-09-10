class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :status, type: Integer
  has_many :users
  belongs_to :course
end
