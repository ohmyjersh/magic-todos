use Mix.Config

config :todo_service, TodoService.Repo, [
  adapter: Ecto.Adapters.Postgres,
  database: "todo_service_#{Mix.env}",
  username: "postgres",
  password: "",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox]

config :logger,
  backends: [:console],
  level: :warn,
  compile_time_purge_level: :info