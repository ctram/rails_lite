require 'uri'
require 'byebug'

module Phase5
  class Params
    def initialize(req, route_params = {})
      query_string = req.query_string
      body = req.body

      query_string_hash = parse_www_encoded_form(query_string) unless query_string.nil?
      body_hash = parse_www_encoded_form(body) unless body.nil?

      if query_string.nil? and body.nil?
        @params = {}
      elsif query_string.nil?
        @params = body_hash
      elsif body.nil?
        @params = query_string_hash
      else
        @params = body_hash.merge(query_string_hash) do |key, oldval, newval|
          if !newval.nil?
            {oldval.keys.first => oldval.values.first, newval.keys.first => newval.values.first}
          else
            oldval
          end
        end
      end

      @params.merge!(route_params)
    end

    def [](key)
      key = key.to_s
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private

    # Takes a url string and returns the key-value pairs, in an array of key-value pairs. [ [ ], [ ], .....]
    def parse_www_encoded_form(www_encoded_form) # parameter is a url address
      params = {}
      after_question_mark = www_encoded_form.split('?').last
      key_value_pairs = URI::decode_www_form(after_question_mark) # array of keys and values

      # RESULT
      # 'http://www.google.com/?name=mike&height=11'
      #   =>
      # [["name", "mike"], ["height", "11"]]

      # RESULT with nested keys
      # 'http://www.google.com/?user[boss][name]=mike&user[boss][height]=11'
      #   =>
      # [["user[boss][name]", "mike"], ["user[boss][height]", "11"]]

      build_params(key_value_pairs)
    end


    # Takes all key-value pairs (each an array) and generates a hash.
    # Takes in [['user[boss][name]', 'brad'], ['user[boss][height]', 12]]
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
      # RESULT
      # {'user' => {'boss' => {'name' => 'brad', 'height' => 12}}}
    end

    # Takes in array of nested keys, ['user[boss][name]'], and pulls out all
    # the keys and puts them into a single array.
    def parse_key(key)
      if key.include?('[') or key.include?(']')
        key = key.split(/\]\[|\[|\]/)
      else
        [key]
      end
      # RESULT
      # ['user[boss][name]'] => ['user', 'boss', 'name']
    end
  end
end
