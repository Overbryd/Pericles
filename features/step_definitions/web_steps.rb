Before('@authenticated') do
  basic_auth('ftpadmin', 'ASfeir234234sawFwasdf')
end

When /^I visit "([^\"]*)"$/ do |path|
  visit path
end

Then /^I should see "([^\"]*)"$/ do |text|
  response_body.should contain(text)
end

Then /^I should not see "([^\"]*)"$/ do |text|
  response_body.should_not contain(text)
end

When /^I follow "([^\"]*)"$/ do |link|
  click_link link
end

When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |field, content|
  fill_in field, :with => content
end

When /^I press "([^\"]*)"$/ do |button|
  click_button button
end

When /^show response$/ do
  save_and_open_page
end  