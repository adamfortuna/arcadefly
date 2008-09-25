class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "#{HOST}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "#{HOST}"
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject    += 'You have requested to change your password'
    @body[:url]  = "#{HOST}/reset_password/#{user.password_reset_code}"
  end

  def reset_password(user)
    setup_email(user)
    @subject    += 'Your password has been reset.'
  end

  def claim_approval(claim)
    setup_email(claim.profile.user)
    @subject       += "Your claim has been approved for #{claim.arcade.name}"
    @body[:claim]  = claim
    @body[:url]  = "#{HOST}/arcades/#{claim.arcade.permalink}"
  end
  
  def claim_denied(claim)
    setup_email(claim.profile.user)
    @subject       += "Your claim has been denied for #{claim.arcade.name}"
    @body[:claim]  = claim    
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "support@arcadefly.com"
      @subject     = "ArcadeFly.com - "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
