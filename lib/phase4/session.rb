require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)

      if req.cookies
        req.cookies.each do |cookie|
          if cookie.name == '_rails_lite_app'
            @rails_lite_app_cookie = JSON.parse(cookie.value)
            return
          end
        end
      end
      @rails_lite_app_cookie ||= {}
    end

    def [](key)
      @rails_lite_app_cookie[key]
    end

    def []=(key, val)
      @rails_lite_app_cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      jsonified_cookie = @rails_lite_app_cookie.to_json
      cookie = WEBrick::Cookie.new('_rails_lite_app', jsonified_cookie)
      res.cookies << cookie
    end
  end
end
