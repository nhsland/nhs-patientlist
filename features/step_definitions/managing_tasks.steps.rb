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

Given /^that list has a task "(.*?)"$/ do |task_name|
  patient_list = PatientList.find_by_name!('Sick People')
  patient = Patient.last
  to_do_item = patient_list.to_do_items.build(description: task_name)
  to_do_item.patient = patient
  to_do_item.save!
end

Given /^there is another patient list$/ do
  PatientList.make!(name: "Another List")
end

When /^I add the task "(.*?)"$/ do |task_name|
  fill_in "to_do_item_description", with: task_name
  click_button 'Add Task'
end

When /^I mark the task "(.*?)" as pending$/ do |task_name|
  click_button 'Pending'
end

When /^I mark the task "(.*?)" as done$/ do |arg1|
  click_button 'Done'
end

When /^I start the handover for the list$/ do
  click_link 'Handover to do items'
end

When /^I mark the task "(.*?)" to hand over$/ do |task_name|
  check task_name
end

When /^I select another patient list to hand over to$/ do
  select "Another List", from: "Patient Lists"
  click_button "Handover to do items"
end

Then /^the patient will have a todo task "(.*?)"$/ do |task_name|
  page.should have_css '.todo.tasks .task', text: task_name
end

Then /^the patient will have a pending task "(.*?)"$/ do |task_name|
  page.should have_css '.pending.tasks .task', text: task_name
end

Then /^the patient will have a done task "(.*?)"$/ do |task_name|
  page.should have_css '.done.tasks .task', text: task_name
end

Then /^the other patient list will have a task "(.*?)"$/ do |task_name|
  other_patient_list = PatientList.find_by_name("Another List")
  other_patient_list.to_do_items.where(description: task_name).count.should == 1
end
