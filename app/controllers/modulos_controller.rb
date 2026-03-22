class ModulosController < ApplicationController
  # GET /modulos
  def index
    respond_to do |format|
      format.html 
      
      format.json do
        page = (params[:page] || 1).to_i
        per_page = 5
        
        total_registros = Modulo.count
        total_paginas = (total_registros.to_f / per_page).ceil
        
        modulos = Modulo.order(id: :desc).limit(per_page).offset((page - 1) * per_page)

        render json: {
          modulos: modulos,
          total_paginas: total_paginas,
          pagina_actual: page
        }
      end
    end
  end

  # GET /modulos/:id
  def show
    modulo = Modulo.find(params[:id])
    render json: modulo
  end

  # ¡AQUÍ ESTÁ LA ACCIÓN CREATE QUE NO ENCONTRABA!
  # POST /modulos
  def create
    modulo = Modulo.new(modulo_params)
    if modulo.save
      render json: { success: true, message: 'Módulo creado correctamente.' }
    else
      render json: { success: false, errors: modulo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /modulos/:id
  def update
    modulo = Modulo.find(params[:id])
    if modulo.update(modulo_params)
      render json: { success: true, message: 'Módulo actualizado correctamente.' }
    else
      render json: { success: false, errors: modulo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /modulos/:id
  def destroy
    modulo = Modulo.find(params[:id])
    modulo.destroy
    render json: { success: true, message: 'Módulo eliminado correctamente.' }
  end

  private

  def modulo_params
    params.require(:modulo).permit(:strNombreModulo)
  end
end