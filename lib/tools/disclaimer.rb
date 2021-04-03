module Tools
  class Disclaimer
    def initialize(columns: 80, horizontal_character: '=', vertical_character: '|')
      @columns = columns
      @horizontal_character = horizontal_character
      @vertical_character = vertical_character
    end

    # Prints a box containing a title and an
    # explanation of the action that will be
    # performed.
    #
    # Example:
    #
    # ========================================
    # |                                      |
    # |        POSTGRESQL BACKUP GEM         |
    # |                                      |
    # ========================================
    # |                                      |
    # |  Dolore ipsum sunt amet laborum      |
    # |  voluptate elit tempor minim         |
    # |  officia ex amet incididunt.         |
    # |                                      |
    # ========================================
    def show(title:, text:)
      puts ''
      puts horizontal_character * columns
      puts empty_line
      puts centralized_text(title)
      puts empty_line
      puts horizontal_character * columns
      puts empty_line
      paragraphs = break_text_into_paragraphs(text)
      paragraphs.each do |text|
        puts left_aligned_text(text)
      end
      puts empty_line
      puts horizontal_character * columns
      puts ''
    end

    # Create an empty line to give visual space for the text
    # inside the disclaimer box.
    #
    # Example:
    #
    # |                                      |
    #
    # Returns a string that represents an empty line,
    # including the vertical characters to close the
    # disclaimer box.
    def empty_line
      spaces = ' ' * (columns - 2 * vertical_character.length)

      [
        vertical_character,
        spaces,
        vertical_character
      ].join
    end

    # Create a line inside the disclaimer box with a text aligned
    # in the center of the box. There are cases when the centralized
    # text needs an extra space to complete the box, if you want to
    # learn more about how this is calculated, read the documentation
    # of the method extra_space.
    #
    # Example:
    #
    # |        POSTGRESQL BACKUP GEM         |
    #
    # Return a string with a centralized text inside the disclaimer
    # box.
    def centralized_text(text)
      gap = (columns - text.length - 2 * vertical_character.length) / 2
      spaces = ' ' * gap

      [
        vertical_character,
        spaces,
        text + extra_space(text),
        spaces,
        vertical_character
      ].join
    end

    # Create a line inside the disclaimer box with a text aligned
    # in the left of the box.
    #
    # Example:
    #
    # |  Dolore ipsum sunt amet laborum      |
    #
    # Return a string with a left-aligned text inside the
    # disclaimer box.
    def left_aligned_text(text)
      stripped_text = text.strip
      spaces_around_text = 2
      gap = (columns - 2 * spaces_around_text - 2 * vertical_character.length) - stripped_text.length
      spaces = ' ' * gap

      [
        vertical_character,
        ' ' * spaces_around_text,
        stripped_text,
        spaces,
        ' ' * spaces_around_text,
        vertical_character
      ].join
    end

    private

    attr_reader :columns, :horizontal_character, :vertical_character

    # When the differente between the number of columns and the lenght
    # of the text is odd, there will be a missing space to close the
    # disclaimer box. That's because the division by 2 ceils the result.
    #
    # Example:
    #
    # Consider a box with 40 columns and the text `text`. To calculate
    # the spaces around the text, first substract the vertical characters:
    #
    # 40 - 2 (we are supposing that the vertical character has length 1)
    #
    # Now, substract the length of the text and divide the result by 2 (
    # each portion will be positioned at one side of the text):
    #
    # (38 - 5) / 2 = 16!
    #
    # If we add the numbers back, we have: 2 (vertical_character) + 2 * 16 (spaces) + 5 (text length) = 39
    #
    # The result is not 40, but it should be. In these cases, the need to
    # add an extra space to compensate for this mathematical operation.
    #
    # Returns either one blank space or an empty space.
    def extra_space(text)
      if (text.length.odd? && columns.even?) || (text.length.even? && columns.odd?)
        ' '
      else
        ''
      end
    end

    # Given a long text, this method breaks the text in small
    # chunks that will fit inside the space delimited by the
    # `columns` attribute.
    #
    # Returns an array of string.
    def break_text_into_paragraphs(text)
      paragraphs = []
      position = 0
      spaces_around_text = 2
      paragraph_max_size = columns - 2 * spaces_around_text - 2 * vertical_character.length

      loop do
        break paragraphs if position == text.size

        match = text.match(/.{1,#{paragraph_max_size}}(?=[ ]|\z)|.{,#{paragraph_max_size-1}}[ ]/, position)
        return nil if match.nil?

        paragraphs << match[0]
        position += match[0].size
      end
    end
  end
end