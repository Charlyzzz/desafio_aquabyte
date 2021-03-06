defmodule Aquabyte.Janitor do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: Aquabyte.Janitor)
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_call(:run, _from, state) do
    analizar_imagenes()
    {:reply, :ok, state}
  end

  defp analizar_imagenes do
    File.cd!('./imagenes')
    File.ls!
    |> Flow.from_enumerable
    |> Flow.filter_map(&Imagen.nombre_valido?/1, &Imagen.desde_nombre_archivo/1)
    |> Flow.group_by(&id_imagen/1)
    |> Flow.map(&reporte_para/1)
    |> Enum.each(&IO.puts/1)
  end

  defp reporte_para({id, grupo}), do: Imagen.reporte_para(id, grupo)

  defp id_imagen({id, _, _, _}), do: id
end