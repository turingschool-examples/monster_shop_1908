class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  validates_numericality_of :zip, only_integer: true
  validates_length_of :zip, is: 5

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    orders.distinct.joins(:user).pluck(:city)
  end

  def orders
    Order.where(id: ItemOrder.where(item_id: items.pluck(:id)).pluck(:order_id))
  end
end
