class ModulosController < ApplicationController
  # Filtro de seguridad: Solo afecta al acceso inicial (HTML)
  before_action :exigir_permiso_html, only: [:index]

  def index
    respond_to do |format|
      format.html # Carga la cáscara de la vista
      
      format.json do
        # 1. Validación de seguridad para JSON: Bloquea si no hay permiso de consulta
        unless puede_consultar?("modulo")
          return render json: { success: false, errors: ["No autorizado"] }, status: :forbidden
        end

        page = (params[:page] || 1).to_i
        per_page = 5
        total_registros = Modulo.count
        total_paginas = (total_registros.to_f / per_page).ceil
        
        modulos = Modulo.order(id: :desc).limit(per_page).offset((page - 1) * per_page)

        render json: {
          modulos: modulos,
          total_paginas: total_paginas,
          pagina_actual: page,
          # 👇 ENVÍO DE PERMISOS: Usamos view_context para no perder el alcance (scope)
          permisos: {
            editar: view_context.puede_editar?("modulo"),
            eliminar: view_context.puede_eliminar?("modulo")
          }
        }
      end
    end
  end

  def create
    # 2. Validación de seguridad: Solo crea si tiene permiso de Agregar
    if puede_agregar?("modulo")
      @modulo = Modulo.new(modulo_params)
      if @modulo.save
        render json: { success: true, message: 'Módulo creado correctamente.' }
      else
        render json: { success: false, errors: @modulo.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { success: false, errors: ["No tienes permiso para agregar."] }, status: :forbidden
    end
  end

  def update
    # 3. Validación de seguridad: Solo actualiza si tiene permiso de Editar
    if puede_editar?("modulo")
      @modulo = Modulo.find(params[:id])
      if @modulo.update(modulo_params)
        render json: { success: true, message: 'Módulo actualizado correctamente.' }
      else
        render json: { success: false, errors: @modulo.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { success: false, errors: ["No tienes permiso para editar."] }, status: :forbidden
    end
  end

  def destroy
    # 4. Validación de seguridad: Solo elimina si tiene permiso de Eliminar
    if puede_eliminar?("modulo")
      @modulo = Modulo.find(params[:id])
      if @modulo.destroy
        render json: { success: true, message: 'Eliminado correctamente.' }
      else
        render json: { success: false, errors: ["No se pudo eliminar."] }, status: :conflict
      end
    else
      render json: { success: false, errors: ["No tienes permiso para eliminar."] }, status: :forbidden
    end
  end

  private

  # Seguridad de Strong Parameters
  def modulo_params
    params.require(:modulo).permit(:strNombreModulo)
  end

  # Redirección en caso de intentar acceder a la vista HTML sin permiso
  def exigir_permiso_html
    unless puede_consultar?("modulo")
      redirect_to root_path, alert: "Acceso denegado a Módulos."
    end
  end
end