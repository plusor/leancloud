#encoding: utf-8
LeanCloud::Base.register "LiveRoom", namespace: "classes/LiveRoom" do
  extend  ActiveModel::Naming
  include ActiveModel::Validations

  only :create, :update, :show, :destroy, :search

  cattr_accessor :columns, :status_hash
  self.columns = %i(objectId title sourceTitle sourceType sourceId status cover liveTopic liveStartAt liveEndAt hosts avosGroup admins event_id)
  self.status_hash     = {open: "开启", closed: "关闭", hidden: "隐藏", ready: "待开启"}
  attr_accessor *columns

  validates :title, :event_id, :status, :cover, :liveTopic, :liveStartAt, :liveEndAt, :hosts, :admins, presence: true
  validates :status, :inclusion => { :in => status_hash.keys.map(&:to_s) }

  class << self

    def primary_key
      :id
    end

    def find(*args,&block)
      new show(*args, &block)
    end

    def find_by_id(id)
      find(id)
    end

    def create_with_upload(attributes,&block)
      room = new(attributes)
      return room.errors if !room.valid?

      apply(room)

      result = create_without_upload(room.attributes, &block)

      Rails.logger.info result.to_json

      if !result.key?("objectId")
        room.errors.add(:base, result)
        room
      else
        room
      end
    end
    alias_method_chain :create, :upload

    def update_with_upload(id, attributes, &block)
      room = new(attributes.merge(objectId: id))
      apply(room)

      result = update_without_upload(room.id, room.attributes.reject {|k, v| v.nil?}, &block)

      Rails.logger.info result.to_json

      if result.key?("objectId")
        room.errors.add(:base, result)
        room
      else
        room
      end
    end
    alias_method_chain :update, :upload

    # 更新图片, 创建群聊
    def apply(object)
      cover = object.cover
      if !cover.is_a?(Hash) && cover.present?
        request = LeanCloud::File.upload(cover.original_filename) do |req|
          req.headers["Content-Type"] = cover.content_type
          req.body = cover.tempfile.read
        end

        if !request.is_a?(Hash) || !request.key?("objectId")

          object.errors.add(:base, request)
          raise "图片上传失败"
        end

        object.cover = {
          objectId: request["objectId"],
          className: "_File",
          __type: "Pointer"
        }
      end

      object.avosGroup = {
        __type: "Pointer",
        objectId: LeanCloud::AVOSRealtimeGroups.create(m: [])["objectId"],
        "className" => 'AVOSRealtimeGroups'
        } if object.id.blank? && !object.avosGroup.is_a?(Hash)
    end
  end

  def initialize(attrs={})
    assign_attributes(attrs)
  end

  def id
    objectId
  end

  def to_param
    id
  end

  def persisted?
    !id.nil?
  end

  def event_id=(val)
    event = Event.find(val)
    self.sourceTitle = event.title
    self.sourceType = event.class.name
    self.sourceId = val
    @event_id = val
  end

  def event_id
    @event_id || sourceType == "Event" && sourceId
  end

  def event
    @event ||= sourceType.constantize.find(sourceId)
  end

  def uuid
    event.try(:uuid) rescue nil
  end

  def assign_attributes(attrs={})
    multi_parameter_attributes = []
    attrs.symbolize_keys.slice(*self.class.columns).each do |attribute, value|
      send("#{attribute}=", value)
    end
  end

  def attributes
    self.class.columns.map {|attribute| [attribute, instance_variable_get("@#{attribute}")]}.to_h
  end

  def hide
    update(status: "hidden")
  end

  def update(attrs={})
    self.class.update(id, attrs) if id.present?
  end

  def destroy
    self.class.destroy(id)
  end

  def destroy_with_relation
    LeanCloud::File.destroy(cover["objectId"])
    LeanCloud::AVOSRealtimeGroups.destroy(avosGroup["objectId"])
    destroy_without_relation
  end

  alias_method_chain :destroy, :relation
  
  def hosts=(val)
    @hosts = val.is_a?(Array) ? val : split_area(val)
    @hosts << uuid if uuid && !@hosts.include?(uuid)
  end

  def hosts
    Array.wrap(@hosts).join("\n")
  end

  def admins=(val)
    @admins = val.is_a?(Array) ? val : split_area(val)
    @admins << uuid if uuid && !@admins.include?(uuid)
  end

  def admins
    Array.wrap(@admins).join("\n")
  end

  def split_area(val)
    val.to_s.strip.split(/\r|\n|,|;/).reject {|x| x.blank?}
  end

  def save
    id.present? ? update(attributes) : self.class.create(attributes)
  end

  def to_key
    [id]
  end

  def status_name
    self.class.status_hash[status.to_sym]
  end

  def liveStartAt=(val)
    return @liveStartAt=val if val.is_a?(Hash)
    @liveStartAt = {
      __type: "Date",
      "iso" => val.to_time(:utc).iso8601(3)
    }
  end

  def liveEndAt=(val)
    return @liveEndAt=val if val.is_a?(Hash)
    @liveEndAt = {
      __type: "Date",
      "iso" => val.to_time(:utc).iso8601(3)
    }
  end

  def liveStartAt
    @liveStartAt.is_a?(Hash) && @liveStartAt["iso"].to_time
  end

  def liveEndAt
    @liveEndAt.is_a?(Hash) && @liveEndAt["iso"].to_time
  end

  # 踢人
  def kick(ids=[])
    update(hosts: {__op: "Remove", objects: ids}) if ids.present?
  end

  # 查看聊天记录
  def logs
    LeanCloud::Message.logs(convid: avosGroup["objectId"]) if avosGroup.is_a?(Hash).present?
  end
end