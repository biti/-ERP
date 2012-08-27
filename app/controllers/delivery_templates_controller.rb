# encoding: utf-8

class DeliveryTemplatesController < ApplicationController  
  
  def index
    @templates = @current_user.delivery_templates
  end
  
  def new
    @template = @current_user.delivery_templates.new(:width => '300', :height => '140')
    logger.debug LOGISTICS_COMPANIES.to_json
  end
  
  def create
    # options = {}
    # params[:field_position].values.each do |field, position|
    #   options[field] = position.gsub('px', '')
    # end

    @template = DeliveryTemplate.new(params[:delivery_template])
    @template.options = params[:field_position].values.to_json
    @template.fields = params[:fields].values.to_json
    @template.user_id = @current_user.id
    
    if @template.save
      redirect_to delivery_templates_path, :notice => '保存成功'
    else
      render :action => new
    end
  end
  
  def edit
    @template = DeliveryTemplate.find(params[:id])
    @options = JSON.parse(@template.options).map { |item| class_eval(item) }.to_json
  end

  def update
    params[:delivery_template][:options] = params[:field_position].values.to_json
    
    @template = DeliveryTemplate.find(params[:id])
    @template.fields = params[:fields].values.to_json
        
    logger.debug "url=======%s" % edit_delivery_template_path(@template.id)
    if @template.update_attributes(params[:delivery_template])
      redirect_to delivery_templates_path, :notice => '保存成功'
    else
      @options = JSON.parse(@template.options).map { |item| class_eval(item) }.to_json
      render :action => :edit
    end
  end
  
  def destroy
    @template = DeliveryTemplate.find(params[:id])
    @template.destroy

    redirect_to(delivery_templates_path, :notice => "删除成功。")
  end
end
