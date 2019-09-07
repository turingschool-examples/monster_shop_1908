class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  enum status: { pending: 0, packaged: 1, shipped: 2 , cancelled: 3 }

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def items_count
    item_orders.sum(:quantity)
  end

  def merchant_items(merchant)
    items.where(merchant_id: merchant.id)
  end

  def qty_item_in_order(item)
    item_orders.find_by(item_id: item.id).quantity
  end

  def find_item_status(item)
    item_orders.find_by(item_id: item.id).status
  end
end
