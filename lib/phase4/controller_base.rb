require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      session.store_session(@res)
      super
    end

    def render_content(content, content_type)
      session.store_session(@res)
      super
    end

    # Phase4::ControllerBase inherits from Phase3::ControllerBase. Override the #redirect_to and #render_content methods to (1) call the parent's method definition and (2) call Session#store_session.
    # method exposing a `Session` object

    # Test your work: run bin/p04_session_server.rb. Run the spec/p04_session_spec.rb specfile.
    #

    def session
      @session ||= Session.new(@req)
    end
  end
end
