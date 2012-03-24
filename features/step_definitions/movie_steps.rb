
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie    
  end
end

Then /the director of "([^"]*)" should be "([^"]*)"/ do |movie, director|
  assert Movie.find_by_title(movie).director == director
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert page.body.index(e1) < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(/,\s*/).each do |rating|
    step %{I #{uncheck ? 'un' : ''}check "ratings_#{rating}"}
  end
end

Then /I should see (\d+) movies/ do |count|
  within 'table#movies > tbody' do
    assert_equal all('tr').size, count.to_i
  end
end

Given /I (un)?check all of the ratings/ do |uncheck|
  step "I #{uncheck ? 'un' : ''}check the following ratings: #{Movie.all_ratings*','}"
end

Then /I should see all of the movies/ do
  step "I should see #{Movie.count} movies"
end
