# 短信验证API接口
LeanCloud::Base.register "Sms" do
  # /1.1/requestSmsCode	
  # 请求发送短信验证码
  route :requestSmsCode, via: :post
  # /1.1/verifySmsCode/<code>
  # 验证短信验证码
  match "verifySmsCode/:code", via: :post, as: :verify_sms_code
end