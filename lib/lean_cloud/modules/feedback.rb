# 用户反馈组件接口
LeanCloud::Base.register "Feedback", namespace: "feedback" do
  # /1.1/feedback
  # 提交新的用户反馈
  only :create
end