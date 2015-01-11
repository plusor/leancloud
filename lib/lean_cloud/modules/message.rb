LeanCloud::Base.register "Message", namespace: "rtm/messages" do
  only :create
  # /1.1/rtm/messages/logs/
  # 获得应用聊天记录
  route :logs
end