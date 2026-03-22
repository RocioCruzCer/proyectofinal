require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Configuración para que funcione en Render
  config.hosts << ".onrender.com"

  # Los ajustes especificados aquí tendrán prioridad sobre los de config/application.rb.

  # El código no se recarga entre solicitudes.
  config.enable_reloading = false

  # Eager load carga todo el código al arrancar para mejor rendimiento.
  config.eager_load = true

  # Desactiva informes de errores detallados.
  config.consider_all_requests_local = false

  # Activa el almacenamiento en caché de fragmentos.
  config.action_controller.perform_caching = true

  # Encabezados para el servidor de archivos públicos.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Almacenamiento de Active Storage (usando local para el proyecto escolar).
  config.active_storage.service = :local

  # Configuración de Logs.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.silence_healthcheck_path = "/up"

  # --- COMENTAMOS LAS SIGUIENTES LÍNEAS PARA EVITAR ERRORES DE BASE DE DATOS ---

  # config.cache_store = :solid_cache_store
  
  # Al comentar esto, Rails usará el adaptador por defecto (async) que no requiere otra DB.
  # config.active_job.queue_adapter = :solid_queue
  # config.solid_queue.connects_to = { database: { writing: :queue } }

  # ----------------------------------------------------------------------------

  config.active_support.report_deprecations = false
  config.action_mailer.default_url_options = { host: "example.com" }
  config.i18n.fallbacks = true
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]
end