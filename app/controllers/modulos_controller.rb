class ModulosController < ApplicationController
  # Filtro de seguridad: Solo afecta al acceso inicial (HTML)
  before_action :exigir_permiso_html, only: [:index]

  def index
    respond_to do |format|
      format.html # Carga la cáscara de la vista
      
      format.json do
        # 1. Validación de seguridad para JSON
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
          permisos: {
            editar: puede_editar?("modulo"),
            eliminar: puede_eliminar?("modulo")
          }
        }
      end
    end
  end

  def create
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
    if puede_eliminar?("modulo")
      @modulo = Modulo.find(params[:id])
      if @modulo.destroy
        render json: { success: true, message: 'Eliminado.' }
      else
        render json: { success: false, errors: ["No se pudo eliminar."] }, status: :conflict
      end
    else
      render json: { success: false, errors: ["No tienes permiso para eliminar."] }, status: :forbidden
    end
  end

  private

  def modulo_params
    params.require(:modulo).permit(:strNombreModulo)
  end

  # Nueva lógica de seguridad: Redirige solo si es HTML, si es JSON manda error limpio
  def exigir_permiso_html
    unless puede_consultar?("modulo")
      redirect_to root_path, alert: "Acceso denegado a Módulos."
    end
  end
end