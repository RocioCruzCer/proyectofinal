class PrincipalesController < ApplicationController
  # 1. SEGURIDAD: Antes de entrar a la vista, verificamos si tiene permiso de consultar
  # Nota: usamos los nombres tal cual los pusiste en la Base de Datos para los módulos
  before_action -> { exigir_permiso("principal1_1") }, only: [:principal1_1]
  before_action -> { exigir_permiso("principal1_2") }, only: [:principal1_2]
  before_action -> { exigir_permiso("principal2_1") }, only: [:principal2_1]
  before_action -> { exigir_permiso("principal2_2") }, only: [:principal2_2]

  def principal1_1
    # Datos "de mentira" para mostrar en la tabla
    @datos = [
      { id: 1, nombre: "Dato de prueba A", estatus: "Activo" },
      { id: 2, nombre: "Dato de prueba B", estatus: "Inactivo" }
    ]
  end

  def principal1_2
    @datos = [ { id: 1, nombre: "Ejemplo 1.2", estatus: "Activo" } ]
  end

  def principal2_1
    @datos = [ { id: 1, nombre: "Ejemplo 2.1", estatus: "Activo" } ]
  end

  def principal2_2
    @datos = [ { id: 1, nombre: "Ejemplo 2.2", estatus: "Activo" } ]
  end

  private

  def exigir_permiso(modulo)
    unless view_context.puede_consultar?(modulo)
      redirect_to dashboard_path, alert: "No tienes permiso para ver #{modulo}"
    end
  end
end