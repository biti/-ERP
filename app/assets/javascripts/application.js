// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require underscore-min
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require highcharts.src
//= require kindeditor

//= require erp
//= require dashboard
//= require charts
//= require orders
//= require deliveries
//= require products

function cartProd(list) {
    var first = list[0];
    var rest = list.slice(1);

    if (first) {
        var output = [];

        if (rest.length > 0) {
            var prod_rest = cartProd(rest);

            for (var i = 0; i < prod_rest.length; i++) {
                for (var j = 0; j < first.length; j++) {
                    output.push([first[j]].concat(prod_rest[i]));
                }
            }
        } else {
            for (var j = 0; j < first.length; j++) {
                output.push([first[j]]);
            }
        }

        return output;
    } else {
        return [];
    }
}