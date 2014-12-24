# 文件接口
LeanCloud::Base.register "LiveFile", namespace: "classes/LiveFile" do
  # https://leancloud.cn/1.1/classes/LiveFile
  only :create, :show, :search, :update, :destroy

  cattr_accessor :columns
  self.columns = %i(file liveRoom userUUID selected mime_type)

end