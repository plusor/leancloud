# LeanCloud

This project rocks and uses MIT-LICENSE.


## Usage

```
gem "lean_cloud"

LeanCloud::Feedback.create({}) # 用户反馈
LeanCloud::Function.run(function)
....
```
### 更多请查看 lib/lean_cloud/modules

# 配置

```
LeanCloud.configure do
  config.app_id     = "11f6ad8ec52a2984abaafd7c3b516503785c2072"
  config.app_key    = "11f6ad8ec52a2984abaafd7c3b516503785c2072"
  config.master_key = "11f6ad8ec52a2984abaafd7c3b516503785c2072"
  config.host       = "https://leancloud.cn"
  config.version    = "1.1"
end
```

# 在数据管理中添加一个class(GameScore)后:

```
# the namespace option will generate https://leancloud.cn/1.1/classes/GameScore
LeanCloud.register "GameScore", namespace: "classes/GameScore" do
  only :create, :update, :show, :destroy, :search

  # GET https://leancloud.cn/1.1/classes/GameScore/sms/:code
  match "sms/:code", via: :get, as: get_code  # LeanCloud::GameScore.get_code(code) 
  # GET https://leancloud.cn/1.1/sms/:code
  match "sms/:code", via: :get, as: get_code, unscope: true  # LeanCloud::GameScore.get_code(code)
  # GET https://leancloud.cn/1.1/classes/GameScore/:id/sms/:code
  match "sms/:code", via: :get, as: get_code, on: :member  # LeanCloud::GameScore.get_code(id, code)
  
  # GET https://leancloud.cn/1.1/classes/GameScore/result
  route :result
end
```

```
然后使用如下方式进行调用接口
LeanCloud::GameScore.create({score: 'xxx'})
LeanCloud::GameScore.show("11f6ad8ec52a2984abaafd7c3b516503785c2072")
LeanCloud::GameScore.update("11f6ad8ec52a2984abaafd7c3b516503785c2072", {score: 'e'})
LeanCloud::GameScore.destroy("11f6ad8ec52a2984abaafd7c3b516503785c2072")
LeanCloud::GameScore.search(where: {post: {_type: 'xxx'}})
```