Given("you are on the family home page") do 
    visit "/family/home"
    assert_equal "/family/home", current_path
  end
  
  When("you click on the {string} panel") do |panel_name|
    click_on(panel_name)
  end
  
  Then("you are on the meeting choice page") do |page_path|
    assert_equal page_path, current_path
  end
  
  When("you click on a meeting link") do
    # Assuming you have a specific way to identify and click on a meeting link
    click_on("Meeting Link")
  end
  
  Then("you are on the meeting manage page") do |page_path|
    assert_equal page_path, current_path
  end
  
  When("you click the {string} button") do |button_text|
    click_button(button_text)
  end
  
  
  