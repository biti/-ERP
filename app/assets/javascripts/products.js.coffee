App.Views.Products.SelectCategory = 
  init: ->
    $("#first_level_category_id").click -> 
      that = $(this);
      $.get '/products/category_children?parent_id=' + that.val(), (result)->
        that.next().html(result)

        
App.Views.Products.CustomProperties = 
      
  init: ->
    
    $('.check-property-value').on 'change', (event) ->
      that = $(this)
      skuTable = $('#skus-tbody')
      
      arr = []
      $(".properties-input").each ->
        property = $(this).val()
        els = $("input[data-property='" + property + "']").filter('.check-property-value').filter(':checked')
        propertyValues = _.map els, (el) -> $(el).attr('data-property-value')
        propertyValues = _.without propertyValues, ''

        if _.isEmpty(propertyValues)
          return false
        
        # console.debug propertyValues
        arr.push propertyValues
      
      skusArr = []
      _.each arr[0], (color) ->
        _.each arr[1], (size) ->
          skusArr.push( [color, size] )
      
      skuTrs = ''
      _.each skusArr, (item, t) ->
        skuTr = $("<tr></tr>")  
        _.each item, (i, index) ->
          skuTd = $("<td><input readonly='readonly' class='input-mini' name=product[skus_attributes][" + t + "][value_" + index + "] value='" + i + "'/></td>")
          skuTr.append(skuTd)
        
        skuTr.append("<td><input name='product[skus_attributes][" + t + "][price]' class='input-mini'/></td><td><input name='product[skus_attributes]["+ t + "][num]' class='input-mini'/></td><td><input name='product[skus_attributes][" + t + "][custom_id]' class='input-mini'/></td>")
        skuTrs += skuTr.get(0).outerHTML
      
      skuTable.html skuTrs
