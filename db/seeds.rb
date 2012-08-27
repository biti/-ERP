# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:username => 'admin', :password => '888888', :realname => '东方不败')

CustomerLevel.create(
  :name => '普通客户',
  :total_amount => 1,
  :total_orders => 1,
  :level => 1
)
CustomerLevel.create(
  :name => '高级客户',
  :total_amount => 200,
  :total_orders => 3,
  :level => 2
)
CustomerLevel.create(
  :name => 'VIP客户',
  :total_amount => 2000,
  :total_orders => 10,
  :level => 3
)
CustomerLevel.create(
  :name => '至尊VIP客户',
  :total_amount => 50000,
  :total_orders => 20,
  :level => 4
)
# 
# 1.upto(5) do |i|
#   DayData.create(:user_id => 1, :year=>2012, :month=>8,:day=>i, :total_sales => rand(2000), 
#     :total_products=>rand(20), :total_orders => rand(10), :total_customers=> rand(10), :total_new_customers=>rand(4))
# end