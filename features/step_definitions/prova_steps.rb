Given("the user is on the page {string}") do |page|
    visit page
  end
  
  When("the user clicks the {string} button in the form") do |button_text|
    click_button button_text
  end
  
  Then("the user is directed to the page index") do 
    expect(current_path).to eq(root_path)
  end
  