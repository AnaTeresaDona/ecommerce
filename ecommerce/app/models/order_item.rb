class OrderItem < ApplicationRecord
  belongs_to :variant
  belongs_to :order
end
