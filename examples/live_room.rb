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

    def id
      objectId
    end

    def create_with_upload(attributes,&block)
      room = new(attributes)
      return room.errors if !room.valid?

      cover = room.cover
      request = LeanCloud::File.upload(cover.original_filename) do |req|
        req.headers["Content-Type"] = cover.content_type
        req.body = cover.tempfile.read
      end

      if !request.is_a?(Hash) || !request.key?("objectId")

        room.errors.add(:base, request)
        return room
      end

      attributes[:cover] = {
        objectId: request["objectId"],
        className: "_File",
        __type: "Pointer"
      }

      attributes[:avosGroup] = {
        __type: "Pointer",
        objectId: LeanCloud::AVOSRealtimeGroups.create(m: [])["objectId"],
        "className" => 'AVOSRealtimeGroups'
      }

      result = create_without_upload(attributes, &block)

      Rails.logger.info result.to_json

      if !request.is_a?(Hash) || result.key?("objectId")
        room.errors.add(:base, result)
        room
      else
        room
      end
    end
    alias_method_chain :create, :upload
  end

  def initialize(attrs={})
    assign_attributes(attrs)
  end

  def event_id=(val)
    event = Event.find(val)
    self.sourceTitle = event.title
    self.sourceType = event.class.name
    self.sourceId = val
    @event_id = val
  end

  def event
    @event ||= sourceType.constantize.find(sourceId)
  end

  def assign_attributes(attrs={})
    attrs.symbolize_keys.slice(*self.class.columns).each do |attribute, value|
      send("#{attribute}=", value)
    end
  end

  def attributes
    self.class.columns.map {|attribute| [attribute, send(attribute)]}.to_h
  end

  def hide
    update(status: "hidden")
  end

  def update(attrs={})
    self.class.update(id, attrs) if id.present?
  end
  
  def hosts=(val)
    @hosts = val.to_s.split(',') if val.present?
  end

  def admins=(val)
    @admins = val.to_s.split(',') if val.present?
  end

  def save
    id.present? ? update(attributes) : self.class.create(attributes)
  end

  def destroy
    self.class.destroy(id)
  end

  def to_key
    [id]
  end

  def status_name
    STATUS[status.to_sym]
  end

  def liveStartAt=(val)
    @liveStartAt = {
      __type: "Date",
      "iso" => val
    }
  end

  def liveEndAt=(val)
    @liveEndAt = {
      __type: "Date",
      "iso" => val
    }
  end

  # 踢人
  def kick(ids=[])
    update(hosts: {__op: "Remove", objects: ids}) if ids.present?
  end

  # 查看聊天记录
  def logs
    LeanCloud::Message.logs(convid: avosGroup["objectId"]) if avosGroup.is_a?(Hash).present?
  end
  
  # class << self
  #   def self.column_names
  #     ATTRIBUTES
  #   end
  # end
end