require File.expand_path(File.dirname(__FILE__), "lib/simple_dummy.rb")

module HashConstructed
  def initialize(h)
    h.each {|k,v| public_send("#{k}=", v)}
  end
end

class Post
  include HashConstructed
  attr_accessor :id, :title, :user, :comments, :created_at, :published, :meta, :tags
end

class User
  include HashConstructed
  attr_accessor :id, :username, :email
end

class Comment
  include HashConstructed
  attr_accessor :id, :content, :user, :created_at
end

a = SimpleDummy.new("post", 2, {
  filename_with_path: "test/post.yml", 
  associations: [
    {
      klass: "user",
      length: 1,
      filename_with_path: "test/user.yml"
    },
    {
      klass: "comment",
      length: 10,
      filename_with_path: "test/comment.yml",
      associations: [
        {
          klass: "user",
          length: 1,
          filename_with_path: "test/user.yml"
        }
      ]
    }
  ]
}).generate


a = SimpleDummy.new("user", 2, {
  filename_with_path: "test/user.yml"
}).generate


a = SimpleDummy.new("comment", 2, {
  filename_with_path: "test/comment.yml", 
  associations: [
    {
      klass: "user",
      length: 1,
      filename_with_path: "test/user.yml",
    },
    {
      klass: "post",
      length: 1,
      filename_with_path: "test/post.yml",
    }
  ]
}).generate