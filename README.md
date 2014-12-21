# LeanCloud

This project rocks and uses MIT-LICENSE.

# 配置

```
LeanCloud.configure do
  config.app_id   = "11f6ad8ec52a2984abaafd7c3b516503785c2072"
  config.app_key  = "11f6ad8ec52a2984abaafd7c3b516503785c2072"
  config.host     = "https://leancloud.cn"
  config.version  = "1.1"
end
```

# 在数据管理中添加一个class(GameScore)后:

```
LeanCloud.register "GameScore", namespace: "classes/GameScore" do
  only :create, :update, :show, :destroy, :search
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