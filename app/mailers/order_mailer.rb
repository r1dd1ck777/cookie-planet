class OrderMailer < ActionMailer::Base
  def new_order(order)
    @order = order
    admin_emails = AdminUser.pluck(:email)
    mail(to: admin_emails, subject: "Новый заказ #{order.id}")
  end

  def feedback(feedback)
    @feedback = feedback
    admin_emails = AdminUser.pluck(:email)
    mail(to: admin_emails, subject: "Вопрос от пользователя #{feedback.username}")
  end
end