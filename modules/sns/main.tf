resource "aws_sns_topic" "data_notification" {
  name = "data-notification-topic"
}

resource "aws_sns_topic_subscription" "email-subscription" {
  topic_arn = aws_sns_topic.data_notification.arn
  protocol  = "email"
  endpoint  = "vapeprosper@gmail.com"
}
