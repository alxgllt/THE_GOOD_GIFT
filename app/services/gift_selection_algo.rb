class GiftSelection

  def intitialize
    @product_list = []
    Product.all.each do |product|
      @product_list << product
    end
  end

  # actions:
    # entry via step 1
    # entry via step 2

  private
  # intelligence
end
