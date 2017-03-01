class DailyMailer < ApplicationMailer

  def digest(user)
    @questions = Question.created_today
    mail(to: user.email, subject: 'Вопросы созданные сегодня')
  end
end
