defmodule Tadot.CLI.Parser do
  alias Tadot.CLI.Conv

  @allowed_commands [
    version: :string,
    spaghetti: :string
  ]

  def parse(%Conv{valid?: true, stage: :opened} = conv) do
    conv
    |> parse_tokens
    |> parse_command
    |> next
  end

  def parse(conv), do: conv

  defp parse_tokens(%Conv{valid?: true, argv: argv} = conv) do
    try do
      Conv.apply_field(conv, :tokens, extract_tokens(argv))
    catch
      _ ->
        Conv.close_with_error(conv, __MODULE__, %{})
    end
  end

  defp parse_tokens(conv), do: conv

  defp parse_command(%Conv{valid?: true, tokens: tokens} = conv) do
    try do
      Conv.apply_field(conv, :commands, extract_command(tokens))
    catch
      _ ->
        Conv.close_with_error(conv, __MODULE__, %{})
    end
  end

  defp parse_command(conv), do: conv

  defp next(%Conv{valid?: true} = conv) do
    Conv.apply_field(conv, :stage, :parsed)
  end

  defp next(conv), do: conv

  defp extract_tokens(argv) do
    OptionParser.parse(argv, strict: @allowed_commands)
  end

  defp extract_command(tokens) do
    tokens
    |> elem(1)
    |> map_internal_command_representation()
  end

  defp map_internal_command_representation(["version"]) do
    {:version, %{}}
  end

  defp map_internal_command_representation(["browse", url]) do
    {:browse, %{ url: url }}
  end

  defp map_internal_command_representation(["spaghetti"]) do
    {:spaghetti, %{}}
  end
end
