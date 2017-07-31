module ApplicationHelper

  def find_manager(request, role = 'manager' || role = 'director')
    user_id = 0
    request.users.each do |user_in_request|
      if (user_in_request.role.name == role)
        user_id = user_in_request.id
      end
    end
    @follower = request.users.find(user_id)
  end

  def find_designer(request, role = 'designer')
    user_id = 0
    request.users.each do |user_in_request|
      if (user_in_request.role.name == role)
        user_id = user_in_request.id
      end
    end
    @follower = request.users.find(user_id)
  end

  def value_of_product_type(request)
    if request.product_type == 'otro'
      @value = request.name_type
    else
      @value = request.product_type
    end
    @value
  end

  def sum_quantity(requests)
    @result = 0
    requests.each do |r|
      @result += r.quantity
    end
    @result
  end

end
