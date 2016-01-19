module Helper
  def log_in(email, password)
    visit '/login'
    login_fields = all(:css, 'form input')
    login_fields[0].set(email)
    login_fields[1].set(password)
    click_button 'Login'
  end
end
