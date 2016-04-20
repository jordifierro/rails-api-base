module Api
  module V1
    class NoteSerializer < ActiveModel::Serializer
      attributes :id, :title, :content
    end
  end
end
