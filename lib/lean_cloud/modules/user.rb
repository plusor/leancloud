LeanCloud::Base.register "User", namespace: "users" do
  only :create, :update, :show, :destroy, :search
  # /1.1/login	GET	用户登录
  route :login, via: :get, unscope: true
  # /1.1/users/<objectId>/updatePassword	PUT	更新密码，要求输入旧密码。
  route :updatePassword, via: :put, on: :member
  # /1.1/requestPasswordReset	POST	请求密码重设
  route :requestPasswordReset, via: :post
  # /1.1/requestEmailVerify	POST	请求验证用户邮箱
  route :requestEmailVerify, via: :post
  # /1.1/requestMobilePhoneVerify	POST	请求发送用户手机号码验证短信
  route :requestMobilePhoneVerify, via: :post
  # /1.1/verifyMobilePhone/<code>	POST	使用 "验证码" 验证用户手机号码
  match "verifyMobilePhone/:code", via: :post, as: :verify_mobile_phone
  # /1.1/requestLoginSmsCode	POST	请求发送手机号码登录短信。
  route :requestLoginSmsCode, via: :post
  # /1.1/requestPasswordResetBySmsCode	POST	请求发送手机短信验证码重置用户密码。
  route :requestPasswordResetBySmsCode, via: :post
  # /1.1/resetPasswordBySmsCode/<code>	PUT	验证手机短信验证码并重置密码。
  match "resetPasswordBySmsCode/:code", via: :put, as: :reset_password_by_sms_code
end
