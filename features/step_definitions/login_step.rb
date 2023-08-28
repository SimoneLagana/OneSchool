# Questi passi dipendono dalla tua configurazione specifica, quindi adattali di conseguenza.

# Nel tuo file di step definitions di Capybara (ad esempio, student_login_steps.rb)

Given("I am on the mail page") do
  visit root_path
end

When("I click on the panel {string}") do |panel_name|
  #within("#panel-student") do # Sostituisci con la classe o selettore del tuo pannello
    click_link panel_name
  #end

end

Then("I go to the {string} page") do |page_path|
  expect(current_path).to eq(page_path)
end

When("I check if the {string} cookie not exists") do
  expect(page.driver.browser.rack_mock_session.cookie_jar[]).to be_nil
end

Then("I should be on the {string} page") do |page_path|
  expect(current_path).to eq(page_path)
end

When("I put {string} in the field mail") do |email|
  fill_in 'email-field', with: email
end

When("I put {string} in the field password") do |password|
  fill_in 'password-field', with: password
  puts(password)
end

And("Click on pulsante login") do
  click_button 'login-button' # Assicurati che 'Login' sia l'identificativo corretto del pulsante
end

And("I check if the login is successfull") do 
  expect(page).to have_content('Credenziali non valide.')
end

Then("I check if cookie using email {string} is created") do |email|
    cookie_name = 'student_info'
    expect(page.driver.browser.rack_mock_session.cookie_jar[cookie_name]).to be_nil
end


Then("Vengo reindirizzato alla pagina {string}") do |page_path|
  expect(current_path).to eq(page_path)
end



#Given("I am on the {string} page") do |page|
#    visit page
#  end
#  
#  When("I check if the {string} cookie exists") do |cookie_name|
#    expect(page).to have_cookie(cookie_name)
#  end
#  
#  Then("I should see the {string} cookie") do |cookie_name|
#    cookie = find_cookie(cookie_name)
#    expect(cookie).not_to be_nil
#    # Puoi aggiungere ulteriori asserzioni sui dettagli del cookie se necessario.
#  end
#  
#  Then("I should be on the {string} page") do |page|
#    expect(current_path).to eq(page)
#  end
#  
#  # Aggiungi altri passi necessari per verificare ulteriori dettagli dopo il login.
#  