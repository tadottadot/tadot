defmodule Tadot.CLI.Router do
  alias Tadot.CLI.Conv

  def route(%Conv{valid?: true, stage: :parsed} = conv) do
    conv
    |> select
    |> run
    |> next
  end

  def route(conv), do: conv

  defp select(%Conv{valid?: true, commands: commands} = conv) do
    try do
      Conv.apply_field(conv, :runnable, runnable_route(commands))
    catch
      _ ->
        Conv.close_with_error(conv, __MODULE__, %{})
    end
  end

  defp select(conv), do: conv

  defp run(%Conv{valid?: true, runnable: runnable} = conv) do
    conv
    |> Conv.apply_field(:stage, :delegated)
    |> runnable.controller.run()
  end

  defp run(conv), do: conv

  defp next(%Conv{valid?: true} = conv) do
    Conv.apply_field(conv, :stage, :consumed)
  end

  defp next(conv), do: conv

  defp runnable_route({:version, params}) do
    %{
      controller: Tadot.CLI.MainController,
      action: :version,
      params: params
    }
  end

  defp runnable_route({:spaghetti, params}) do
    %{
      controller: Tadot.CLI.MainController,
      action: :spaghetti,
      params: params
    }
  end

  defp runnable_route(_) do
    raise "ROUTE_ERROR"
  end
end
