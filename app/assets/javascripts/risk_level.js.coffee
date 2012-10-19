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
