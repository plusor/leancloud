LeanCloud::Base.register "AVOSRealtimeGroups", namespace: "classes/AVOSRealtimeGroups" do
  self.settings = { host: "https://cn.avoscloud.com" }
  only :create, :update, :show, :search, :destroy
end