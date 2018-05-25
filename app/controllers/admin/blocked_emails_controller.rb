module Admin
  class BlockedEmailsController < AdminController
    def index
      @blocked_emails ||= BlockedEmail.all
    end

    def create
      blocked_email = BlockedEmail.create(blocked_email_params)
      if blocked_email.save
        render json: { message: blocked_email }, status: :ok
      else
        render json: { errors: blocked_email.errors }, status: :internal_server_error
      end
    end

    def destroy
      blocked_email = BlockedEmail.find(blocked_email_params[:id])
      begin
        blocked_email.destroy
        render json: { message: 'success' }, status: :ok
      rescue StandardError => e
        render json: { errors: e }, status: :internal_server_error
      end
    end

    private

    def blocked_email_params
      params.permit(:id, :email, :domain)
    end
  end
end
