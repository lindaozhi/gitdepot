class LineItem < ActiveRecord::Base
  def total_price
    product.price * quantity
  end
  
  belongs_to :product
  belongs_to :cart
  belongs_to :order
end
