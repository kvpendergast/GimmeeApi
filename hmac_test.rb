require 'openssl'
require "base64"

hash = OpenSSL::HMAC.digest('sha256',"R0pkbBP5YgtpR7Qqt+UrLy0HzxB/8PbnKIbyeDSX","Message")
puts Base64.encode64(hash)