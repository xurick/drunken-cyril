class CommentMailer < ActionMailer::Base
  default from: 'comment@mbilify.com'

  def comment_email(comment)
    @comment = comment

    @greeting = 'Hi'

    mail to: 'rick@mbilify.com', subject: 'A New Comment'
  end
end
