class CommentMailer < ActionMailer::Base

  def comment_email(comment)
    @comment = comment

    @greeting = 'Hi'

    mail from: comment.email, to: 'hello@mbilify.com', subject: 'A New Comment'
  end
end
