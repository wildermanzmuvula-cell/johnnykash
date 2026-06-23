# frozen_string_literal: true

require_relative "garudadidada/version"

# Tiny zero-dependency helpers to humanize values:
# byte sizes, durations, English ordinals, and pluralization.
module Garudadidada
  BYTE_UNITS = %w[KB MB GB TB PB EB ZB YB].freeze

  module_function

  # Format a byte count as a human-readable string using binary (1024) units.
  #   Garudadidada.format_bytes(1536) # => "1.5 KB"
  def format_bytes(bytes)
    n = bytes.to_f
    return "#{bytes.to_i} B" if n < 1024

    last = BYTE_UNITS.length - 1
    BYTE_UNITS.each_with_index do |unit, i|
      n /= 1024.0
      return "#{trim(n)} #{unit}" if n < 1024 || i == last
    end
  end

  # Format a duration in seconds as a human-readable string.
  #   Garudadidada.format_duration(3661) # => "1h 1m 1s"
  def format_duration(seconds)
    s = seconds.to_i
    return "0s" if s.zero?

    parts = []
    days, s = s.divmod(86_400)
    hours, s = s.divmod(3_600)
    minutes, s = s.divmod(60)
    parts << "#{days}d" if days.positive?
    parts << "#{hours}h" if hours.positive?
    parts << "#{minutes}m" if minutes.positive?
    parts << "#{s}s" if s.positive?
    parts.join(" ")
  end

  # Return n with its English ordinal suffix.
  #   Garudadidada.ordinal(21) # => "21st"
  def ordinal(num)
    num = num.to_i
    m = num % 100
    suffix = if m.between?(11, 13)
               "th"
             else
               { 1 => "st", 2 => "nd", 3 => "rd" }.fetch(num % 10, "th")
             end
    "#{num}#{suffix}"
  end

  # Return "<count> <singular|plural>" choosing the form based on count.
  #   Garudadidada.pluralize(3, "file") # => "3 files"
  def pluralize(count, singular, plural = nil)
    plural ||= "#{singular}s"
    word = count == 1 ? singular : plural
    "#{count} #{word}"
  end

  def trim(num)
    format("%.1f", num).sub(/\.0$/, "")
  end
  private_class_method :trim
end
