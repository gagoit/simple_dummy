# simple_dummy
Generate dummy data for testing

# Real Problem
Sometimes you will work with other system via their APIs, calling their APIs from your backend, and display this data to your end user. You have been provided an APIs specification that describes the response JSON structure (fields and types), and maybe they also have a Ruby gem that wrapper their APIs response into Ruby objects... That's so great. 

But that APIs can be not avaiable at this time you develop your backend, so it can affect to your project's schedule. 
=> You have to fake some data in your backend that have structure like the response of APIs.

# Usage
See test.rb(https://github.com/gagoit/simple_dummy/blob/master/test/test.rb) for more detail.

## Support types:
SIMPLE_TYPES = ["Integer", "Float", "Boolean", "String", "Time", "Date"]
SPECIAL_TYPES = ["Array", "SingleObject", "Hash"]

- SingleObject: can be another object..
- Array: array of simple types or other objects..
- Hash: with keys and values..
Example:
```ruby
id: Integer
title: String
user:
  type: SingleObject
  kclass: User
comments:
  type: Array
  kclass: Comment
meta:
  type: Hash
  keys:
    description: String
    url: String
tags:
  type: Array
  kclass: String
created_at: Time
published: Boolean
```

## Generate json only
```ruby
require File.expand_path(File.dirname(__FILE__), "lib/simple_dummy.rb")

# Generate list of posts that have structure defined in the test/post.yml
data = SimpleDummy.new("post", 2, {
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
```

## Wrap the data into Ruby objects
Just define your objects and generate the data.
``` ruby
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
```

## Config the associations:
You can config the name, number of objects, and the structure file location of each association. Like
``` ruby
data = SimpleDummy.new("post", 2, {
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
```
