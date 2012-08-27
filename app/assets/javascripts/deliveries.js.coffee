App.Views.Deliveries.Index =
  init: ->
    submitButton = $("#submit")
    shippingForm = $("#shipping-form")
    saveButton = $("#save-delivery-address-button")
    addressForm = $("#delivery-address-form")
    addressEl = $("#show-address")
    companySelect = $("#wuliu_company")
    address = "<%=@address%>"
    
    if address is ""
      addressEl.hide()
      addressForm.show()
    else
      addressEl.show()
      addressForm.hide()
    addressEl.find("a").click ->
      addressEl.hide()
      addressForm.show()

    saveButton.click ->
      $.post("/deliveries/save_address", addressForm.serialize()).success (response) ->
        addressForm.hide()
        addressEl.find("span").html response.address
        addressEl.show()

    deliveryNoEls = $("#shipping-form .delivery-no")
    firstDeliveryNoEl = deliveryNoEls.first()

    # 自动联想快递单号
    firstDeliveryNoEl.change ->
  
      #　判断物流公司选了没
      company = companySelect.val()
      if company is ""
        companySelect.next().html "请选择物流公司"
        companySelect.parent().parent().attr "class", "control-group error"
        return
  
      # 判断运单号格式
      deliveryNo = $(this).val()
      noFormat = _.find(App.Constants.LOGISTICS_COMPANIES, (item) ->
        item["ename"] is company
      )["no_format"]
      pattern = new RegExp(noFormat)
      unless pattern.exec(deliveryNo)
        firstDeliveryNoEl.next().html "运单号格式有误"
        return
      i = /[0-9]+/.exec(deliveryNo)[0]
      deliveryNoEls.each ->
        no_ = deliveryNo.replace(/[0-9]+/, i++)
        $(this).val no_


    firstDeliveryNoEl.keyup ->
      firstDeliveryNoEl.next().html ""

    companySelect.change ->
      $(this).parent().parent().attr "class", "control-group"
      companySelect.next().html ""

    submitButton.click ->
  
      #　判断物流公司选了没
      company = companySelect.val()
      if company is ""
        companySelect.next().html "请选择物流公司"
        companySelect.parent().parent().attr "class", "control-group error"
        return
      arr = []
      deliveryNoEls.each ->
        $this = $(this)
        arr.push $this.attr("id")  if $this.val() is ""

      if arr.length > 0
        _.each arr, (id) ->
          $("#" + id).next().html "运单号没有填写"

        return
    
      $this = $(this)
      $this.html "发货中..."
      $this.attr "class", "btn btn-success btn-large disabled"
      $.post("/deliveries/shipping_in_volume", shippingForm.serialize() + "&delivery_company=" + companySelect.val()).success (response) ->
        alert "批量发货成功！"
        $this.html "批量发货成功"
        window.location = "/deliveries"

