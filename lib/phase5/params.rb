require 'uri'
require 'byebug'

module Phase5
  class Params
    def initialize(req, route_params = {})
      byebug
      query_string = req.query_string
      body = req.body
      byebug

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
      byebug
      @params.merge!(route_params)
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

    def build_params(data)
      # unless data.include?('[')
      #   key = data.split('=').first
      #   val = data.split('=').last
      #   return
      # end
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

    def self.nest(keys, val)
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
