App.Views.Charts.Index =
  init: ->
    yearSelect = $("#filter_date_1i")
    monthSelect = $("#filter_date_2i")
    
    this.loadDatas yearSelect.val(), monthSelect.val()
    
    yearSelect.change ->
      this.loadDatas yearSelect.val(), monthSelect.val()

    monthSelect.change ->
      this.loadDatas yearSelect.val(), monthSelect.val()      
    
  loadDatas: (year, month) ->
    options1 =
      chart:
        renderTo: "chart1"
        height: 300

      title:
        text: "销售额"

      xAxis: {}
      yAxis: [
        min: 0
        title:
          text: ""

        labels:
          formatter: ->
            @value + "元"
      ]
      series: [
        name: "销售额"
        color: "#4572A7"
        type: "column"
      ]

    options2 =
      chart:
        renderTo: "chart2"
        height: 300

      title:
        text: "销量/订单"

      xAxis: {}
      yAxis:
        min: 0
        title:
          text: ""

      series: [
        name: "销量"
        type: "spline"
      ,
        name: "订单量"
        color: "#AA4643"
        type: "spline"
      ]

    options3 =
      chart:
        renderTo: "chart3"
        height: 300

      title:
        text: "用户"

      xAxis: {}
      yAxis: [
        min: 0
        title:
          text: ""
      ]
      series: [
        name: "客户数量"
        color: "#4572A7"
        type: "spline"
      ,
        name: "新客户数量"
        color: "#AA4643"
        type: "spline"
      ]
      
    showCurrentMonth = $("#show-current-month")
    totalSalesTd = $("#total-sales-td")
    totalProductsTd = $("#total-products-td")
    totalOrdersTd = $("#total-orders-td")
    totalCustomersTd = $("#total-customers-td")
    totalNewCustomersTd = $("#total-new-customers-td")
  
    url = "/charts/month_datas.json?year=" + year + "&month=" + month
    $.get(url).success (data) ->
      showCurrentMonth.html data.year + data.month
      totalSalesTd.html data.month_data.total_sales
      totalProductsTd.html data.month_data.total_products
      totalOrdersTd.html data.month_data.total_orders
      totalCustomersTd.html data.month_data.total_customers
      totalNewCustomersTd.html data.month_data.total_new_customers
      
      options1.xAxis.categories = data.day_data.days
      options1.series[0].data = data.day_data.total_sales
      new Highcharts.Chart(options1)
      
      options2.xAxis.categories = data.day_data.days
      options2.series[0].data = data.day_data.total_products
      options2.series[1].data = data.day_data.total_orders
      new Highcharts.Chart(options2)
      
      options3.xAxis.categories = data.day_data.days
      options3.series[0].data = data.day_data.total_customers
      options3.series[1].data = data.day_data.total_new_customers
      new Highcharts.Chart(options3)
    
