module Embulk
  module Formatter
    class MarkdownTable < FormatterPlugin
      Plugin.register_formatter("markdown_table", self)
      VALID_ENCODINGS = %w(UTF-8 UTF-16LE UTF-32BE UTF-32LE UTF-32BE)
      NEWLINES = {
        'CRLF' => "\r\n",
        'LF' => "\n",
        'CR' => "\r",
        'NUL' => "\0",
        'NO' => '',
      }

      def self.join_texts((*inits,last), opt = {})
        delim = opt[:delimiter] || ', '
        last_delim = opt[:last_delimiter] || ' or '
        [inits.join(delim),last].join(last_delim)
      end

      def self.transaction(config, schema, &control)
        task = {
          'encoding' => config.param('encoding', :string, default: 'UTF-8'),
          'newline' => config.param('newline', :string, default: 'LF')
        }

        encoding = task['encoding'].upcase
        raise "encoding must be one of #{join_texts(VALID_ENCODINGS)}" unless VALID_ENCODINGS.include?(encoding)

        newline = task['newline'].upcase
        raise "newline must be one of #{join_texts(NEWLINES.keys)}" unless NEWLINES.has_key?(newline)

        yield(task)
      end

      def init
        @header_print = true
        @encoding = task['encoding'].upcase
        @newline = NEWLINES[task['newline'].upcase]
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
            header  = "|" + page.schema.map(&:name).join('|') + "|#{@newline}"
            header += "|" + (["---"] * page.schema.size).join('|') + "|#{@newline}"
            @current_file.write header.encode(@encoding)
            @header_print = false
          end

          row = "|" + record.join('|') + "|#{@newline}"
          @current_file.write row.encode(@encoding)
        end
      end

      def finish
        file_output.finish
      end
    end
  end
end
