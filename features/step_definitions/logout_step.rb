Given("I am a school staff user with email and password") do 
    FactoryBot.create(:school)
    FactoryBot.create(:class_room)
    FactoryBot.create(:school_staff)
  end
  
  Given("I am in the app main page") do
    visit root_path
  end 

  When("I click on the main panel {string}") do |panel_name|
    click_link panel_name
    end

   And("I press the right button to login") do
        click_button 'login-button' 
      end

      Then("I should be in the staff's login page") do 
        expect(current_path).to eq(school_staff_login_path)
      end
  Then("I should be on my the school staff's home page") do 
    expect(current_path).to eq(school_staff_home_path)
  end

  When ("I insert my correct mail and password") do 
    fill_in 'password-field', with: 'pas'
    fill_in 'email-field', with: 'aldo@moro'
  end
  
  When ("I click on the profile panel") do
    click_link ('Profile')
  end
  
  Then ("I should be on my profile page") do
    expect(current_path).to eq(school_staff_profile_path)
  end
  
  And ("I should see my email displayed") do
    expect(page).to have_content('aldo@moro')
  end
  
  When ('I click on the logout button') do
    click_button 'Logout'
  end
  Then ("I should be on the main page") do
    expect(current_path).to eq(root_path)
  end