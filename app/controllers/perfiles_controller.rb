class PerfilesController < ApplicationController
  # GET /perfiles
  def index
    respond_to do |format|
      # 1. Si el navegador pide HTML, le mostramos la pantalla normal
      format.html 
      
      # 2. Si JavaScript (Fetch API) pide JSON, le mandamos los datos paginados
      format.json do
        # Paginación de 5 en 5
        page = (params[:page] || 1).to_i
        per_page = 5
        
        total_registros = Perfil.count
        total_paginas = (total_registros.to_f / per_page).ceil
        
        # Traemos solo 5 perfiles dependiendo de la página
        perfiles = Perfil.order(id: :desc).limit(per_page).offset((page - 1) * per_page)

        render json: {
          perfiles: perfiles,
          total_paginas: total_paginas,
          pagina_actual: page
        }
      end
    end
  end

  # GET /perfiles/:id
  def show
    perfil = Perfil.find(params[:id])
    render json: perfil
  end

  # POST /perfiles
  def create
    perfil = Perfil.new(perfil_params)
    if perfil.save
      render json: { success: true, message: 'Perfil creado correctamente.' }
    else
      render json: { success: false, errors: perfil.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /perfiles/:id
  def update
    perfil = Perfil.find(params[:id])
    if perfil.update(perfil_params)
      render json: { success: true, message: 'Perfil actualizado correctamente.' }
    else
      render json: { success: false, errors: perfil.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /perfiles/:id
  def destroy
    perfil = Perfil.find(params[:id])
    perfil.destroy
    render json: { success: true, message: 'Perfil eliminado correctamente.' }
  end

  private

  # Seguridad: Solo permitimos que se envíen estos dos campos a la base de datos
  def perfil_params
    params.require(:perfil).permit(:strNombrePerfil, :bitAdministrador)
  end
end