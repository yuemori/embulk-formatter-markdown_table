module Embulk
  module Formatter

    class MarkdownTable < FormatterPlugin
      Plugin.register_formatter("markdown_table", self)

      def self.join_texts((*inits,last), opt = {})
        delim = opt[:delimiter] || ', '
        last_delim = opt[:last_delimiter] || ' or '
        [inits.join(delim),last].join(last_delim)
      end

      def self.transaction(config, schema, &control)
        task = {}

        yield(task)
      end

      def init
        @header_print = true
        @current_file = nil
        @current_file_size = 0
      end

      def close
      end

      def add(page)
        page.each do |record|
          if @current_file == nil || @current_file_size > 32*1024
            @current_file = file_output.next_file
            @current_file_size = 0
            @header_print = true
          end

          if @header_print
            @current_file.write "|#{page.schema.map(&:name).join('|')}|\n"
            @current_file.write "|#{(["---"] * page.schema.size).join('|')}|\n"
            @header_print = false
          end

          file_output.write "|#{record.join('|')}|\n"
        end
      end

      def finish
        file_output.finish
      end
    end

  end
end
