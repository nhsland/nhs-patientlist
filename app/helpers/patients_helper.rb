module PatientsHelper

  def full_name(patient)
    "#{patient.firstnames} #{patient.lastname}"
  end

end
