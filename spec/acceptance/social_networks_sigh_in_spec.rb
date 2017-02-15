require_relative 'acceptance_helper'

feature 'Social networks sign in', %q{
  In order to sign in with social network
  As an quest
  I want to be able to sign in via social nwtwork
} do

  scenario 'facebook' do
    OmniAuth.config.add_mock(:facebook, { uid: '36362' })
    visit new_user_session_path
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Please confirm your email address.'

    fill_in 'Email', with: 'test@ema.il'
    click_on 'Continue'
    open_email('test@ema.il')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email was confirmed. Now u can sign in.'

    visit new_user_session_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(current_path).to eq root_path
  end

  context 'twitter' do
    # auth with email, but in my case its nil, but it can be not nil
    scenario 'with email' do
      OmniAuth.config.add_mock(:twitter, { uid: '36362', info: { email: 'tw@t.er'} })
      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end

    scenario 'without email' do
      OmniAuth.config.add_mock(:twitter, { uid: '36362' })
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Please confirm your email address.'

      fill_in 'Email', with: 'test@ema.il'
      click_on 'Continue'
      open_email('test@ema.il')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email was confirmed. Now u can sign in.'

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end
    
  end

end
