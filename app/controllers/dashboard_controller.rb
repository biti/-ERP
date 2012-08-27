# encoding: utf-8


class DashboardController < ApplicationController
  
  MIN = 5
  
  def index
    @orders = @current_user.orders.where("status = ?", 'wait_seller_delivery').limit(7)
    @shortage_skus = @current_user.skus.where("quantity < ?", MIN).includes('product').order('quantity').limit(7)

    @days, @datas = recent_7_days_datas
    @test = {:a => 1, :b => 2}
    logger.debug "json======%s" % @datas.inspect
  end
  
  def recent_datas
    @days_json, @datas_json = recent_7_days_datas
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => {:days => @days_json, :datas => @datas_json} }
    end
  end
  
  private
  
  def recent_7_days_datas
    now = Time.now
    if now.day >= 7
      days = now.day-6 .. now.day
      day_datas = @current_user.day_datas.where(:month => now.month, :day => days).to_a
      
      days = days.map { |day| "#{now.month}.#{day}" }
    else
      days_in_month = Time.days_in_month(1.month.ago.month, now.year)
      last_month_days = (days_in_month-6+now.day .. days_in_month).to_a
      this_month_days = (1 .. now.day).to_a
      
      day_datas = @current_user.day_datas.where(:month => 1.month.ago.month, :day => last_month_days).to_a
      day_datas += @current_user.day_datas.where(:month => now.month, :day => this_month_days).to_a
      
      days = (last_month_days + this_month_days).map { |day| "#{now.month}.#{day}" }
    end
    
    days[-3..-1] = '前天', '昨天', '今天'

    arr = []
    days.each do |day|
      if data = day_datas.find { |item| "#{item.month}.#{item.day}" == day }
        arr << data
      else
        arr << DayData.new(:total_orders => 0, :total_sales => 0, :total_customers => 0)
      end
    end
    
    return days, arr
  end
  
end
