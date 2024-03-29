class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy, :change_payment]


  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = Registration.all
    @deposited_registrations = Registration.deposit_only.alphabetical.paginate(:page => params[:page]).per_page(10)
    @paid_registrations = Registration.paid.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
  end

  # GET /registrations/new
  def new
  end

  # GET /registrations/1/edit
  def edit
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Registration.new(registration_params)
    @camp = Camp.find(@registration.camp_id)
      if @registration.save
        redirect_to @camp, notice: 'Registration was successfully created.'
      else
         render action: 'new' 
      end
  end

  def change_payment
    @registration.payment_status = 'full'
    @registration.save
    redirect_to student_path(@registration.student)
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    respond_to do |format|
      if @registration.update(registration_params)
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to registrations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:camp_id, :student_id, :payment_status, :points_earned)
    end
end
