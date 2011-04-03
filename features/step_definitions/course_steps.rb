Given /^the following courses:$/ do |courses|
  Course.create!(courses.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) course$/ do |pos|
  visit courses_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following courses:$/ do |expected_courses_table|
  expected_courses_table.diff!(tableish('table tr', 'td,th'))
end
