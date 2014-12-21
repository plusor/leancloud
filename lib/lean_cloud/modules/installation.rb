# 安装数据
LeanCloud::Base.register "Installation", namespace: "installations" do
  only :create, :update, :show, :destroy, :search
end