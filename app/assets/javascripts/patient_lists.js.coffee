# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

show_risk_level = (container, risk_level) ->
  $(container).find(".inner").removeClass("low-risk medium-risk high-risk").addClass("#{risk_level}-risk")

$ ->
  $(".patient.full").each (i, patient_detail) ->
    $(patient_detail).find(".risk-level").each (i, row) ->
      checked = $(row).find("input[type='radio']:checked")
      risk_level = checked.val()
      show_risk_level(patient_detail, risk_level)

      $(row).find("input[type='radio']").click (evt) ->
        $(this).parents("form").submit()
        show_risk_level(patient_detail, $(this).val())
        
  $('.list-items-toggle').click (evt) ->
    evt.preventDefault()
    list_items = $(this).parents('.list-item-footer').find('.list-items')
    list_items.toggleClass("hide")
    $(this).html if list_items.hasClass("hide") then "[+]" else "[-]"
