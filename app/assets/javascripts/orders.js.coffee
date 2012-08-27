App.Views.Orders.Index = 

  getCheckedIds: ->
    ids = []
    $("input:checked").each ->
      ids.push $(this).attr("data-id")

    ids
    
  init: ->
    that = this
    shippingButton = $("#shipping-in-volume-button")
    modifyShipFeeButton = $("#modify-ship-fee-button")
    remarkButton = $("#remark-button")
    modifyShipFeeModal = $("#modify-ship-fee-modal")
    modifyShipFeeSubmit = $("#modify-ship-fee-submit")
    shipFeeInput = $("#order_ship_fee")
    
    $(".address-button").popover placement: "right"
    
    checkboxs = $('#orders-table tbody tr td input[type="checkbox"]');
    $("#check-all-yes").click ->
      checkboxs.attr "checked", true

    $("#check-all-no").click ->
      checkboxs.attr "checked", false

    shippingButton.click ->
      ids = that.getCheckedIds()
      return false  if ids.length is 0
      
      window.location = "/deliveries/edit_delivery?ids=" + ids.join(",")

    modifyShipFeeButton.click ->
      ids = that.getCheckedIds()
      return false  if ids.length is 0
      
      modifyShipFeeModal.modal()

    modifyShipFeeSubmit.click ->
      ids = that.getCheckedIds()
      return false  if ids.length is 0

      shipFee = shipFeeInput.val()
      url = "/orders/update_ship_fee?ids=" + ids.join(",") + "&ship_fee=" + shipFee
      $.get(url).success (response) ->
        if response.sub_msg
          alert response.sub_msg
        else
          modifyShipFeeModal.modal "hide"
          _.each response, (order) ->
            $("#payment-" + order.id + " strong").html order.payment
            $("#payment-" + order.id).effect "highlight", {}, 2000



