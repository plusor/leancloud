# 角色接口
LeanCloud::Base.register "Role", namespace: "roles" do
  only :create, :update, :show, :destroy, :search
end