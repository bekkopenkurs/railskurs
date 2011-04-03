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

Given /^a valid course exist$/ do
  Course.create!({
      :code => "VALID-COURSE",
      :name => "A valid course",
      :credit => 7.5,
      :assessments => 4,
      :mandatory_activities => 2,
      :teacher => "Torstein Nicolaysen"
  })
end

Then /^I should see the course's code$/ do
  @course = Course.find_by_code("VALID-COURSE")
  Then "I should see \"#{@course.code}\" within \"#course-details .course-code\""
end

Then /^I should see a course's name$/ do
  @course = Course.find_by_code("VALID-COURSE")
  Then "I should see \"#{@course.name}\" within \"#course-details .course-name\""
end

Then /^I should see the course's credits$/ do
  @course = Course.find_by_code("VALID-COURSE")
  Then "I should see \"#{@course.credit}\" within \"#course-details .course-credit\""
end

Then /^I should see how many assessments there are in the course$/ do
  @course = Course.find_by_code("VALID-COURSE")
  Then "I should see \"#{@course.assessments}\" within \"#course-details .course-assessments\""
end

Then /^I should see how many mandatory activities there are in the course$/ do
  @course = Course.find_by_code("VALID-COURSE")
  Then "I should see \"#{@course.mandatory_activities}\" within \"#course-details .course-mandatory-activities\""
end

Then /^I should see the name of the teacher for the course$/ do
  @course = Course.find_by_code("VALID-COURSE")
  Then "I should see \"#{@course.teacher}\" within \"#course-details .course-teacher\""
end
