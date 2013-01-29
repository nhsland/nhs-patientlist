require 'machinist/active_record'

Patient.blueprint do
  firstnames { 'Joe '}
  lastname   { 'Bloggs' }
  patstamp   { Time.gm(2012, 07, 13, 23, 5) }
  hospno     { "456" }
end

Patient.blueprint(:admitted) do
  admissions {
    admission = Admission.new
    admission.admhospno = object.hospno
    admission.admstatus = 'Admitted'
    admission.admstamp  = DateTime.now
    [admission]
  }
end

Admission.blueprint do
  admstatus { "Admitted" }
  admstamp  { Time.gm(2012, 07, 13, 23, 5) }
end

Grade.blueprint do
  title     { "Consultant #{sn}" }
  rank      { 1 }
end

ToDoItem.blueprint do
  description  { "Task #{sn}"  }
  patient      { Patient.make! :hospno => "999#{sn}"}
  patient_list { PatientList.make! }
  grade        { Grade.make! }
end

User.blueprint do
  email    { "test-#{sn}@example.com" }
  password { "password" }
  grade    { Grade.make! }
end

PatientList.blueprint do
  name { "Test List - #{sn}" }
end

Membership.blueprint do
  risk_level   { "low" }
  patient_list { PatientList.make! }
  patient      { Patient.make! }
end

HandoverItem.blueprint do
  to_do_item        { ToDoItem.make! }
  patient_list_from { PatientList.make! }
  patient_list_to   { PatientList.make! }
end
