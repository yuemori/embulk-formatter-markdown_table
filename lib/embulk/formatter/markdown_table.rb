module Embulk
  module Formatter

    class MarkdownTable < FormatterPlugin
      Plugin.register_formatter("markdown_table", self)
      VALID_ENCODINGS = %w(UTF-8 UTF-16LE UTF-32BE UTF-32LE UTF-32BE)
      NEWLINES = {
        'CRLF' => "\r\n",
        'LF' => "\n",
        'CR' => "\r"
      }

      def self.join_texts((*inits,last), opt = {})
        delim = opt[:delimiter] || ', '
        last_delim = opt[:last_delimiter] || ' or '
        [inits.join(delim),last].join(last_delim)
      end

      def self.transaction(config, schema, &control)
        task = {
          'encoding' => config.param('encoding', :string, default: 'UTF-8'),
          'newline' => config.param('newline', :string, default: 'LF'),
          'date_format' => config.param('date_format', :string, default: nil),
          'timezone' => config.param('timezone', :string, default: nil )
        }

        encoding = task['encoding'].upcase
        raise "encoding must be one of #{join_texts(VALID_ENCODINGS)}" unless VALID_ENCODINGS.include?(encoding)

        newline = task['newline'].upcase
        raise "newline must be one of #{join_texts(NEWLINES.keys)}" unless NEWLINES.has_key?(newline)

        yield(task)
      end

      def init
        @encoding = task['encoding'].upcase
        @newline = NEWLINES[task['newline'].upcase]

        # your data
        @current_file == nil
        @current_file_size = 0
      end

      def close
      end

      def add(page)
        page.each do |record|
          if @current_file == nil || @current_file_size > 32*1024
            @current_file = file_output.next_file
            @current_file_size = 0
          end
          @current_file.write "|mydata|"
        end
      end

      def finish
        file_output.finish
      end
    end

  end
end
