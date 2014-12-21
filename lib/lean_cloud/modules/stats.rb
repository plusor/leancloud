LeanCloud::Base.register "Stats",namespace: "stats" do
  # /1.1/stats/appinfo
  # 获取应用的基本信息
  route :appinfo, via: :post
  # /1.1/stats/appmetrics
  # 获取应用的具体统计数据
  route :appmetrics, via: :post
end