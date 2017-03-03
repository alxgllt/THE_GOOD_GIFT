class GiftSelectionService
  private
  attr_reader :cart

  public

  def initialize(cart)
    @cart = cart
  end

  def call
    return if cart.gift_number == cart.cart_products.count

    products = products_filtered
    products_updated = remove_cart_products(products)
    available_cash = calc_available_cash
    default_bundle_config = default_bundle_configuration(available_cash)
    product_list = list_format(products_updated, available_cash, default_bundle_config)

    return sorting_matching_list(product_list)
  end

  private

  def sorting_matching_list(product_list)
    return product_list.sort_by! { |product| product[:sell_priority].to_i }
  end

  def list_format(products, available_cash, default_bundle_config)
    product_list = []

    products.each do |product|
      if product.price_cents >= default_bundle_config[:min_proportion] * available_cash &&
          product.price_cents <= default_bundle_config[:max_proportion] * available_cash
        product_list << product
      end
    end

    return product_list
  end

  def default_bundle_configuration(available_cash)
    default_bundle_config = {
      gift_number: cart.gift_number,
      min_proportion: 0.4,
      max_proportion: 0.7
    }

    if cart.products.count == cart.gift_number - 1
      default_bundle_config[:min_proportion] = 0.8
      default_bundle_config[:max_proportion] = 1
    end

    default_bundle_config
  end

  def calc_available_cash
    if cart.products.empty?
      cart.price * 100 * 0.95
    else
      cart.price * 100 - ( cart.products.inject(0) { |sum, product| sum + product.price_cents } )
    end
  end

  def remove_cart_products(products)
    # TODO: use ActiveRecord to filter products
    products.select { |product| !cart.include?(product) }
  end

  def products_filtered
    products = Product.all

    if cart.tags
      products = products.where("tag_one IN (?) OR tag_two IN (?)", cart.tags, cart.tags)
    end

    if cart.gender
      products = products.where(gender: [(cart.gender == "Homme" ? "M" : "F"), "U"])
    end

    return products
  end
end
