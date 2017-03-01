class AnswerMailer < ApplicationMailer

  def answer_published(user, question, answer)
    @user = User.find(user)
    @question = question
    @answer = answer
    mail(to: @user.email, subject: 'Новый ответ на вопрос')
  end
end
