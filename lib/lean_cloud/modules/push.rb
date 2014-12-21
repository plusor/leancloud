# 推送通知
LeanCloud::Base.register "Push", namespace: "push" do
  # /1.1/push	POST	推送通知
  only :create
end