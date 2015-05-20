require 'uri'
require 'byebug'

module Phase5
  class Params
    def initialize(req, route_params = {})
      byebug
      request_query_string = req.query_string
      request_body = req.body

      unless request_query_string.nil? or request_query_string.include?('[') or request_query_string.include?(']')
        key = request_query_string.split('=').first
        val = request_query_string.split('=').last
        @params = {key => val}
        return
      end

      hash_params_query_string = build_params(request_query_string) unless request_query_string.nil?
      hash_params_body = build_params(request_body) unless request_body.nil?

      if hash_params_body.nil?
        @pararms = hash_params_query_string
      elsif hash_params_query_string.nil?
        @params = hash_params_body
      else
        @params = hash_params_body.merge(hash_params_query_string) do |key, oldval, newval|
          if !newval.nil?
            {oldval.keys.first => oldval.values.first, newval.keys.first => newval.values.first}
          else
            oldval
          end
        end
      end
    end
=begin
  h11.merge(h22) do |key, oldval, newval|
   if !newval.nil?
     {oldval.keys.first => oldval.values.first, newval.keys.first => newval.values.first}
   else
     oldval
   end
  end

  {:user=>{:name=>"hank", :height=>12}}

=end

    def [](key)
      key = key.to_s
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    # private

    def parse_www_encoded_form(www_encoded_form)

      params = {}

      params_from_url = URI::decode_www_form(www_encoded_form) # array of keys and values
      #  RESULT =>
        # [["user[house][name]", "Disneyland"], ["user[house][address]", "haight"]]
      self.build_params(params_from_url)

      # build_params(params_from_url)
    end

    def build_params(data)

      params = {}

      data.each do |pair|

        keys = parse_key(pair.first) # array

        val = pair.last

        current = params

        keys.each.with_index do |key, idx|

          if idx == keys.length - 1

            current[key] = val

          else

            current[key] ||= {}

            current = current[key]

          end
        end
      end

      params
    end

    def nest(keys, val)
      if keys.length == 1
        return {keys.first => val}
      end
      {keys.first => nest(keys.drop(1), val)}
    end

    def parse_key(keys)
      if keys.include?('[') or keys.include?(']')
        keys = keys.split(/\]\[|\[|\]/)
      else
        [keys]
      end
    end
  end
end
