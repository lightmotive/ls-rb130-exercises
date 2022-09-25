class FileLineComparer
  include Enumerable

  attr_reader :path1_line, :path2_line

  def initialize(path1_line, path2_line)
    @path1_line = path1_line
    @path2_line = path2_line
  end

  def each
    return to_enum unless block_given?

    File.open(path1_line) do |path1_io|
      path1_enum = path1_io.each
      File.open(path2_line) do |path2_io|
        path2_enum = path2_io.each

        loop do
          yield(path1_enum.next.chomp, path2_enum.next.chomp)
        end
      end
    end
  end

  def all_first_transformed_match_second?
    each do |path1_line, path2_line|
      transformed = yield(path1_line)
      return false if transformed != path2_line
    end

    true
  end
end
