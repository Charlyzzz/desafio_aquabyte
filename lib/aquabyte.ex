defmodule Aquabyte do
  use Application

  alias Aquabyte.{Janitor, JanitorSupervisor}

  def start(_, _) do
    JanitorSupervisor.start_link()
  end

  def run_janitor do
    GenServer.call(Janitor, :run)
  end
end
