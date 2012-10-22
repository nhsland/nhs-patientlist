Given /^there is a patient list with a patient$/ do
  Patient.make!(:admitted)
  visit lists_path
  fill_in 'patient_list_name', with: 'Sick People'
  click_button 'Create'
  click_button 'Add to list'
end

Given /^I am viewing the patient list$/ do
  patient_list = PatientList.find_by_name!('Sick People')
  visit list_path(patient_list)
end

When /^I add the task "(.*?)"$/ do |task_name|
  fill_in "to_do_item_description", with: task_name
  click_button 'Add Task'
end

Then /^the patient will have the task "(.*?)" associated with them$/ do |task_name|
  page.should have_css '.patient p', text: task_name
end
