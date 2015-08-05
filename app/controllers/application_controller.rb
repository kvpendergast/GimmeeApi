class ApplicationController < ActionController::Base

def amazonSignature(itemIds, associateTag, operation, responseGroup, service)
	@accesskey = "AKIAIHMGKYWGXDTROKMA"
	@timestamp = "2015-08-10T19%3A37%3A00Z"
	@securitykey = "R0pkbBP5YgtpR7Qqt+UrLy0HzxB/8PbnKIbyeDSX"
	@data = "GET\nwebservices.amazon.com\n/onca/xml\nAWSAccessKeyId=#{@accesskey}&AssociateTag=#{associateTag}&ItemId=#{itemIds[0]}%2C#{itemIds[1]}%2C#{itemIds[2]}%2C#{itemIds[3]}%2C#{itemIds[4]}%2C#{itemIds[5]}%2C#{itemIds[6]}%2C#{itemIds[7]}%2C#{itemIds[8]}%2C#{itemIds[9]}&Operation=#{operation}&ResponseGroup=#{responseGroup}&Service=#{service}&Timestamp=#{@timestamp}"
	@hash = OpenSSL::HMAC.digest('sha256',@securitykey,@data)
	@signature = Base64.encode64(@hash)
	@signature.gsub!('=','%3D')
	@signature.gsub!('+','%2B')
	@signature.gsub!(',','%2C')

	@response = RestClient.get "http://webservices.amazon.com/onca/xml?AWSAccessKeyId=#{@accesskey}&AssociateTag=#{associateTag}&ItemId=#{itemIds[0]}%2C#{itemIds[1]}%2C#{itemIds[2]}%2C#{itemIds[3]}%2C#{itemIds[4]}%2C#{itemIds[5]}%2C#{itemIds[6]}%2C#{itemIds[7]}%2C#{itemIds[8]}%2C#{itemIds[9]}&Operation=#{operation}&ResponseGroup=#{responseGroup}&Service=#{service}&Timestamp=#{@timestamp}&Signature=#{@signature}"

	return @response
end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
end
