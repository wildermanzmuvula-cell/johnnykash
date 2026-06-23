defmodule Garudadidada do
  @moduledoc """
  Tiny zero-dependency helpers to humanize values:
  byte sizes, durations, English ordinals, and pluralization.
  """

  @byte_units ~w(KB MB GB TB PB EB ZB YB)

  @doc """
  Format a byte count as a human-readable string using binary (1024) units.

      iex> Garudadidada.format_bytes(1536)
      "1.5 KB"

      iex> Garudadidada.format_bytes(500)
      "500 B"
  """
  def format_bytes(bytes) when is_integer(bytes) and bytes < 1024, do: "#{bytes} B"

  def format_bytes(bytes) when is_integer(bytes), do: do_bytes(bytes * 1.0, @byte_units)

  defp do_bytes(n, [unit | rest]) do
    n = n / 1024

    if n < 1024 or rest == [] do
      "#{trim(n)} #{unit}"
    else
      do_bytes(n, rest)
    end
  end

  @doc """
  Format a duration in seconds as a human-readable string.

      iex> Garudadidada.format_duration(3661)
      "1h 1m 1s"
  """
  def format_duration(seconds) when is_integer(seconds) and seconds == 0, do: "0s"

  def format_duration(seconds) when is_integer(seconds) do
    days = div(seconds, 86_400)
    rem1 = rem(seconds, 86_400)
    hours = div(rem1, 3_600)
    rem2 = rem(rem1, 3_600)
    minutes = div(rem2, 60)
    secs = rem(rem2, 60)

    [{days, "d"}, {hours, "h"}, {minutes, "m"}, {secs, "s"}]
    |> Enum.filter(fn {v, _} -> v > 0 end)
    |> Enum.map_join(" ", fn {v, u} -> "#{v}#{u}" end)
  end

  @doc """
  Return `n` with its English ordinal suffix.

      iex> Garudadidada.ordinal(21)
      "21st"
  """
  def ordinal(n) when is_integer(n) do
    m = rem(n, 100)

    suffix =
      if m >= 11 and m <= 13 do
        "th"
      else
        case rem(n, 10) do
          1 -> "st"
          2 -> "nd"
          3 -> "rd"
          _ -> "th"
        end
      end

    "#{n}#{suffix}"
  end

  @doc """
  Return `"<count> <singular|plural>"`, choosing the form based on `count`.

      iex> Garudadidada.pluralize(3, "file")
      "3 files"

      iex> Garudadidada.pluralize(2, "person", "people")
      "2 people"
  """
  def pluralize(count, singular, plural \\ nil) when is_integer(count) do
    plural = plural || singular <> "s"
    word = if count == 1, do: singular, else: plural
    "#{count} #{word}"
  end

  defp trim(n) do
    n
    |> :erlang.float_to_binary(decimals: 1)
    |> String.replace_suffix(".0", "")
  end
end
