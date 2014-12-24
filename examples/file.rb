# 文件接口
LeanCloud::Base.register "File", namespace: "files" do
  # https://leancloud.cn/1.1/files/test.png
  # only :create
  match ":filename", via: :post, as: :upload
end