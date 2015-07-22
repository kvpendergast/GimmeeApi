class ApplicationController < ActionController::Base

def amazonSignature(itemId, associateTag, operation, responseGroup, service)
	@accesskey = "AKIAIHMGKYWGXDTROKMA"
	@timestamp = "2015-07-25T19%3A37%3A00Z"
	@securitykey = "R0pkbBP5YgtpR7Qqt+UrLy0HzxB/8PbnKIbyeDSX"
	@data = "GET\nwebservices.amazon.com\n/onca/xml\nAWSAccessKeyId=#{@accesskey}&AssociateTag=#{associateTag}&ItemId=#{itemId}&Operation=#{operation}&ResponseGroup=#{responseGroup}&Service=#{service}&Timestamp=#{@timestamp}"
	@hash = OpenSSL::HMAC.digest('sha256',@securitykey,@data)
	@signature = Base64.encode64(@hash)
	@signature.gsub!('=','%3D')
	@signature.gsub!('+','%2B')

	@response = RestClient.get "http://webservices.amazon.com/onca/xml?AWSAccessKeyId=#{@accesskey}&AssociateTag=#{associateTag}&ItemId=#{itemId}&Operation=#{operation}&ResponseGroup=#{responseGroup}&Service=#{service}&Timestamp=#{@timestamp}&Signature=#{@signature}"

	return @response
end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
end
