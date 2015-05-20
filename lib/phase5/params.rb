require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:

    # INSTRUCTIONS

    def initialize(req, route_params = {})
      @params = {}
    end
    # NB: Your Params#[] getter method should respond indifferently to both symbol and string versions of its keys. In other words, params[:id] and params['id'] should both work.
    #
    # Instantiate a Params object in your controller, as an ivar. This will keep track of the params for the controller.
    def [](key)
      key = key.to_s
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params_from_url = URI::decode_www_form(www_encoded_form) # array of keys and values
      params_from_url.each do |pair|
        @params_from_url[pair.first] = pair.last
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
    end
  end
end
