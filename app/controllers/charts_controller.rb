# encoding: utf-8

class ChartsController < ApplicationController
  
  def month_datas
    @year = params[:year]
    @month = params[:month]
    @month_data = MonthChart.where(:user_id => @current_user.id, :year => @year, :month => @month).first

    unless @month_data
      @month_data = MonthChart.new(:total_sales => 0, :total_products=>0, :total_orders=>0, 
        :total_customers => 0, :total_new_customers => 0)
    end
    
    datas = DayData.where(:user_id => @current_user.id, :year => params[:year], :month => params[:month]) || []
        
    result = {}
    %w{total_sales total_orders total_products total_customers total_new_customers}.each do |item|
      result[item] = generate_datas(datas, item)
    end
    result[:days] = generate_days
    
    logger.debug "json============%s" % {:day_data => result, :month_data => @month_data, :year => @year, :month => @month}
    
    render :json => {:day_data => result, :month_data => @month_data, :year => @year, :month => @month}
  end
  
  private 
  
  def generate_days
    days_in_month = Time.days_in_month(@month.to_i, @year.to_i)
    (1..days_in_month)
  end
  
  def generate_datas(datas, variable)
    hash = datas.inject({}) { |hash, item| hash[item.day] = item.__send__(variable); hash }

    arr = generate_days.inject([]) do |arr, month|
      if hash[month]
        arr << hash[month].to_i
      else
        arr << nil
      end
    end
    
    arr
  end
end
