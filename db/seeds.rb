def with_header(header_message)
  puts header_message
  yield if block_given?
  puts ""
end

## Shifts
#
with_header "Creating shifts..." do
  ["Day", "On Call"].each do |name|
    puts "  #{name}"
    Shift.find_or_create_by_name name
  end
end

## Teams
#
def create_teams(shift, *team_names)
  team_names.each do |team_name|
    puts "  #{shift.name}: #{team_name}"
    team = { name: team_name, shift_id: shift.id }
    t = Team.where(team).first || Team.create(team)
    t.save
  end
end

with_header "Creating default on-call teams" do
  create_teams(Shift.on_call, "Clinical","Surgical")
end

with_header "Creating day shift teams" do
  create_teams(Shift.day, "Ward 1", "Ward 2", "Ward 3", "Cardiac Response")
end
