class OrdersController <ApplicationController

  def new

  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.create((order_params).merge(user_id: current_user.id))
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:notice] = "Your order has been created!"
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def index
    # NOTE: Which is less bad, two ivars or @user.orders in the view?
    @user = current_user
  end

  def update
    order = Order.find(params[:id])
    order.update(status: "Cancelled")
    # item_array = Item.find(order.item_orders.where(fulfilled: true).pluck(:item_id))
    # order.item_orders.joins(:item).where(fulfilled: true)
    item_array.update_all()
    flash[:success] = "Your order has been cancelled"
    redirect_to "/profile"
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
