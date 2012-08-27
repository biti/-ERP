# coding: UTF-8
class CompaniesController < ApplicationController
  
  def index
    @suppliers = Supplier.select('company').where("company like '%#{params[:term]}%'")
    @dans      = Dan.select('partner_name').where("partner_name like '%#{params[:term]}%'")
    render :json => ( @suppliers.map{ |s| s.company } + @dans.map{ |d| d.partner_name } ).uniq
  end
  
end