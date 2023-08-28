# Inserisci questo test nel file spec/features/student_authentication_spec.rb

require 'rails_helper'

RSpec.describe "Student Authentication", type: :feature do
  let(:student) { create(:student, email: 'student@example.com') }

  it "redirects to student/home when student_info cookie is present" do
    # Crea un cookie student_info con l'email dello studente
    page.driver.browser.set_cookie("student_info=#{student.email}")

    visit student_login_path

    # Verifica che il reindirizzamento sia avvenuto con successo
    expect(current_path).to eq(student_home_path)
  end

  it "redirects to student/login when student_info cookie is not present" do
    visit student_login_path

    # Verifica che il reindirizzamento sia avvenuto con successo
    expect(current_path).to eq(student_login_path)
  end
end
