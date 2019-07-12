class ApplicationMailer < ActionMailer::Base
  default from: "TakumaN <pca@takuman.me>" #SESの場合
  layout 'mailer'
end
