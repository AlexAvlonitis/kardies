module Admin
  class BlockedEmailsController < AdminController
    def index
      @blocked_emails ||= BlockedEmail.all
    end

    def create
      blocked_email = BlockedEmail.create(blocked_email_params)
      if blocked_email.save
        render json: { message: blocked_email }, status: 200
      else
        render json: { errors: blocked_email.errors }, status: 402
      end
    end

    def destroy
      blocked_email = BlockedEmail.find(blocked_email_params[:id])
      begin
        blocked_email.destroy
        render json: { message: "success" }, status: 200
      rescue => e
        render json: { errors: e }, status: 402
      end
    end

    private

    def blocked_email_params
      params.permit(:id, :email, :domain)
    end
  end
end
