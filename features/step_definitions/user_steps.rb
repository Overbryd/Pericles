Before do
  Pericles.names.each do |name|
    Pericles.destroy(name)
  end
end

Given /^a user "([^\"]*)\/([^\"]*)"$/ do |name, password|
  Pericles.add(name, password)
end
