# frozen_string_literal: true

class TextAnalyzer
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def process(&block)
    return unless block_given?
    return if File.zero?(file_path)

    File.open(file_path, &block)
  end
end

analyzer = TextAnalyzer.new('02_text_analyzer_sandwich_sample.txt')

analyzer.process do |file|
  paragraph_count = 1
  file.each_line { |line| paragraph_count += 1 if line.match(/^\R{1}$/) }
  puts "#{paragraph_count} paragraphs"
end

analyzer.process do |file|
  line_count = file.each_line.reduce(0) { |count, _| count + 1 }
  puts "#{line_count} lines"
end

analyzer.process do |file|
  word_count = file.each_line.reduce(0) { |count, line| count + line.scan(/\w+/).size }
  puts "#{word_count} words"
end
