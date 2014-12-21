# Cloud 函数接口
LeanCloud::Base.register "Function", namespace: "functions" do
  # /1.1/functions
  # 调用 Cloud Code 函数
  only :create
end