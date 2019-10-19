module Api
  module V1
    class RegistrationsController < ::Devise::RegistrationsController
      skip_before_action :authenticate_scope!
      skip_before_action :doorkeeper_authorize!, only: :create

      def create
        build_resource(sign_up_params)

        resource.save
        if resource.persisted?
          render json: { message: 'Εγγραφήκατε επιτυχώς' }, status: :ok
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
      end

      def update
        self.resource = current_user

        if resource.respond_to?(:unconfirmed_email)
          prev_unconfirmed_email = resource.unconfirmed_email
        end
        if resource.update(account_update_params)
          pic = account_update_params.dig(:user_detail_attributes, :profile_picture)
          resource.user_detail.profile_picture.attach(pic) if pic

          if is_flashing_format?
            flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
              :update_needs_confirmation : :updated
            set_flash_message :notice, flash_key
          end
          bypass_sign_in resource, scope: resource_name
          render json: resource, status: :ok
        else
          clean_up_passwords resource
          set_minimum_password_length
          render json: resource.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

      private

      def current_user
        current_resource_owner
      end

      def current_resource_owner
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def sign_up_params
        params.require(:user).permit(allow_params)
      end

      def update_resource(resource, params)
        resource.update_without_password(params)
      end

      def account_update_params
        params.require(:user).permit(allowed_update_params)
      end

      def allowed_update_params
        [:email, :password, :password_confirmation, user_detail_attrs]
      end

      def allow_params
        [:username, :email, :password, :password_confirmation, user_detail_attrs]
      end

      def user_detail_attrs
        {
          user_detail_attributes: %i[
            id state gender age profile_picture
          ]
        }
      end
    end
  end
end
