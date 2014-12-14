class FuturistsController < ApplicationController
  before_action :set_futurist, only: [:show, :edit, :update, :destroy, :finish_signup]

  # GET /futurists/:id.:format
  def show
    # authorize! :read, @futurist
  end

  # GET /futurists/:id/edit
  def edit
    # authorize! :update, @futurist
  end

  # PATCH/PUT /futurists/:id.:format
  def update
    # authorize! :update, @futurist
    respond_to do |format|
      if @futurist.update(futurist_params)
        sign_in(@futurist == current_futurist ? @futurist : current_futurist, :bypass => true)
        format.html { redirect_to @futurist, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @futurist.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /futurists/:id/finish_signup
  def finish_signup
    # authorize! :update, @futurist 
    if request.patch? && params[:futurist] #&& params[:futurist][:email]
      if @futurist.update(futurist_params)
        @futurist.skip_reconfirmation!
        sign_in(@futurist, :bypass => true)
        redirect_to @futurist, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  # DELETE /futurists/:id.:format
  def destroy
    # authorize! :delete, @futurist
    @futurist.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    def set_futurist
      @futurist = Futurist.find(params[:id])
    end

    def futurist_params
      accessible = [ :name, :email ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:futurist][:password].blank?
      params.require(:futurist).permit(accessible)
    end
end