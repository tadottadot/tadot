defmodule Tadot.CLI do
  @moduledoc """
  The Command Line Interface for Tadot.io
  """

  alias Tadot.CLI.{Conv, Parser, Router}

  def main(argv \\ []) do
    argv
    |> open_conv
    |> parse(Parser)
    |> route(Router)
    |> close_conv
    |> finalize
    |> response
    |> terminate
  end

  defp open_conv(argv) do
    %Conv{argv: argv}
  end

  defp parse(%Conv{valid?: true, stage: :opened} = conv, parser) do
    parser.parse(conv)
  end

  defp route(%Conv{valid?: true, stage: :parsed} = conv, router) do
    router.route(conv)
  end

  defp route(conv, _router), do: conv

  defp close_conv(%Conv{valid?: true, stage: :consumed} = conv) do
    Conv.close(conv)
  end

  defp close_conv(conv), do: conv

  defp finalize(%Conv{stage: :closed} = conv) do
    Conv.finalize(conv)
  end

  defp response(resp) do
    IO.inspect(resp)
  end

  defp terminate(%{error: error}), do: {:error, error}
  defp terminate(%{result: result}), do: result
end
