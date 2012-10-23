Given /^I am viewing the teams page$/ do
  visit teams_path
end

When /^I join the "(.*?)" \- "(.*?)" team$/ do |team_name, shift_name|
  @team = Team.where(name: team_name).detect{|t| t.shift == Shift.find_by_name(shift_name) }
  within(:css, "#team_#{@team.id}") do
    click_button 'Join'
  end
end

Then /^I should be a member of the team$/ do
  @user.teams.include?(@team).should be_true
end

Then /^I should not be able to join the team twice$/ do
  within(:css, "#team_#{@team.id}") do
    page.should_not have_css("input[type='submit']")
  end
end
