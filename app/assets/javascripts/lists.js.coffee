# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

show_risk_level = (container, risk_level) ->
  $(container).removeClass("risk-level-low risk-level-medium risk-level-high").addClass("risk-level-#{risk_level}")

$ ->
  $(".patient-detail").each (i, row) ->
    $(row).find("input[type='radio']").click (evt) ->
      $(this).parents("form").submit()
      show_risk_level($(this).parents(".patient-detail"), $(this).val())
        
  $('.list-items-toggle').click (evt) ->
    evt.preventDefault()
    list_items = $(this).parents('.list-item-footer').find('.list-items')
    list_items.toggleClass("hide")
    $(this).html if list_items.hasClass("hide") then "[+]" else "[-]"
