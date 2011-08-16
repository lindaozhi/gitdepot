class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  PAYMENT_TYPES =["Check","Credit card","Purchase order"]
  
  validates :name, :address, :email, :pay_type, :presence => true
  validates :pay_type, :inclusion => PAYMENT_TYPES
  validates :email, :format => {
    :with => %r{[0-9a-zA-Z]+@[0-9a-zA-Z]+\.[0-9a-zA-Z]+},
    :message=>'your email address is not legal'
  }

  
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
