defmodule Tadot.CLI.Conv do
  alias Tadot.CLI.Conv

  defstruct argv: [],
            tokens: nil,
            commands: nil,
            runnable: nil,
            result: nil,
            cursor: __MODULE__,
            stage: :opened,
            valid?: true,
            error: nil

  def apply_field(%Conv{} = conv, field, value) do
    Map.put(conv, field, value)
  end

  def close(%Conv{} = conv) do
    conv
    |> apply_field(:stage, :closed)
  end

  def close_with_error(%Conv{} = conv, cursor, error) do
    conv
    |> apply_field(:cursor, cursor)
    |> apply_field(:error, error)
    |> close()
  end

  def finalize(%Conv{} = conv) do
    %{
      msg: "conv is finalized with stage: #{conv.stage} at cursor: #{conv.cursor}",
      cursor: conv.cursor,
      stage: conv.stage,
      result: conv.result,
      error: conv.error
    }
  end
end
