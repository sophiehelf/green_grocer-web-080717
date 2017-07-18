require 'pry'

def consolidate_cart(cart)
	new_hash = {}
	cart.each do |hash|
		hash.each do |key, value|
			new_hash[key] = value
			new_hash[key][:count] = 0
		end
	end
	cart.each do |hash|
		hash.each do |key, value|
			if new_hash.key?(key)
				new_hash[key][:count] += 1
			end
		end
	end
	new_hash
end

def apply_coupons(cart, coupons)
	coupons.each do |coupon|
		cart.keys.each do |food| #loop thru keys of cart
			if coupon[:item] == food && coupon[:num] <= cart[food][:count]
				cart["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[food][:clearance], :count => cart[food][:count]/coupon[:num]}
				cart[food][:count] = cart[food][:count] % coupon[:num]
			end
		end
	end
	cart
end

def apply_clearance(cart)
  cart.map do |food, info|
  	if cart[food][:clearance] == true
  		cart[food][:price] = (cart[food][:price] * 0.8).round(2)
  	end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  clearanced_cart = apply_clearance(couponed_cart)
  total = 0 
  clearanced_cart.each do |food, info|
  	total += clearanced_cart[food][:price] * clearanced_cart[food][:count]
  end
  if total > 100
  	total = total * 0.9
  end
  total
end
