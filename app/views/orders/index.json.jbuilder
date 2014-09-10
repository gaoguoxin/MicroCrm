json.array!(@orders) do |order|
  json.extract! order, :id, :status
  json.url order_url(order, format: :json)
end
