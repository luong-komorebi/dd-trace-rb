module Datadog
  # Contains behavior for managing correlations with tracing
  # e.g. Retrieve a correlation to the current trace for logging, etc.
  module Correlation
    # Struct representing correlation
    Identifier = Struct.new(:trace_id, :span_id).tap do |struct|
      # Do this #class_eval here for Ruby 1.9.3 support.
      # Ruby 2.0+ supports passing a block to Struct::new instead.
      struct.class_eval do
        def initialize(*args)
          super
          self.trace_id = trace_id || 0
          self.span_id = span_id || 0
        end

        def to_s
          "dd.trace_id=#{trace_id} dd.span_id=#{span_id}"
        end
      end
    end.freeze

    NULL_IDENTIFIER = Identifier.new.freeze

    module_function

    # Produces a CorrelationIdentifier from the Context provided
    def identifier_from_context(context)
      return NULL_IDENTIFIER if context.nil?
      Identifier.new(context.trace_id, context.span_id).freeze
    end
  end
end
