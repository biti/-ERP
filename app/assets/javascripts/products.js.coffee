App.Views.Products.SelectCategory = 
  init: ->
    $("#first_level_category_id").click -> 
      that = $(this);
      $.get '/products/category_children?parent_id=' + that.val(), (result)->
        that.next().html(result)

        
App.Views.Products.CustomProperties = 
  init: ->
    $(".property-values-input").on 'change', (event)-> 
      that = $(this);
      
      $(".properties-input").each ->
        property = $(this).val()
        els = $("input[data-property='" + $(this).attr('data-property') + "']").filter('.property-values-input')

        propertyValues = _.map els, (el) -> $(el).val()
        propertyValues = _.without propertyValues, ''
        console.debug property, propertyValues

    $('.check-property-value').on 'change', (event) ->
      that = $(this)
