class Datafile
  include Mongoid::Document
  field :data, type: String
  field :datatype, type: String
  field :username, type: String
  field :emails, type: Array, default: []
  validates :data, format: { with: /\A.*\.(jpg|png|gif|jpeg|JPG|PNG|GIF|JPEG|doc|DOC|docx|DOCX|pdf|PDF)\z/,
  message: "only allows jpg, png, gif, jpeg, doc, docx, pdf formats" }, uniqueness: {message: "File already exists."}
  paginates_per 4
  max_paginates_per 4
  
end
