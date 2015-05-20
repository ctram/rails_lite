require 'uri'

module Phase5
  class Params
    def initialize(req, route_params = {})
      # TODO: find method that accesses request body of @req
      @request_body = req.query_string
      @params = {}
    end

    def [](key)
      key = key.to_s
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    # private
    def self.parse_www_encoded_form(www_encoded_form)
      @params = {}
      params_from_url = URI::decode_www_form(www_encoded_form) # array of keys and values
      # 'user[house][name]=Disneyland' = > [['user[house][name]', 'Disneyland']]
      params_from_url.each do |key_value_pair|
        keys = key_value_pair.first
        de_nested_keys = self.parse_key(keys)
        val = key_value_pair.last
        @params = self.nest(de_nested_keys, val)
      end
      @params
      #
      #
      #
      # params_from_url.each do |pair|
      #   @params[pair.first] = pair.last
      # end
      # @params
      # # RESULT
      # 'user=mike' => [['user', 'mike']]
      # 'user[house][name]' => [['user[house][name]', 'Disneyland']]
      # @req.body
    end

    def self.nest(keys, val)
      if keys.length == 1
        return {keys.first => val}
      end
      {keys.first => self.nest(keys.drop(1), val)}
    end

    def self.parse_key(keys)
      if keys.include?('[') or keys.include?(']')
        keys = keys.split(/\]\[|\[|\]/)
      else
        [keys]
      end
    end
  end
end
