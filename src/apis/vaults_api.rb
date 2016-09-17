$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'repositories'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'grape'
require 'vaults_repository'
require 'vault'

class VaultsAPI < Grape::API
    version 'v1'
    prefix :api
    format :json
    resources :vaults do
        get do
            vaults_repository = VaultsRepository.new
            vaults = vaults_repository.find(params)
            return vaults
        end

        get ':id' do
            vaults_repository = VaultsRepository.new
            vaults = vaults_repository.find({ id: params[:id]})
            return vaults
        end

        params do
            requires :name, type: String
            requires :type, type: String
            requires :owner_user_id, type: Integer
            optional :amount, type: Float, default: 0
            optional :style, type: Hash, default: { color: '#000', background_color: '#fff'}
        end
        post do
            vault = Vault.new
            vault.name = params[:name]
            vault.amount = params[:amount]
            vault.type = params[:type]
            vault.style = params[:style]
            vault.details = params[:details]
            vault.owner_user_id = params[:owner_user_id]
            vaults_repository = VaultsRepository.new
            created_vault = vaults_repository.insert_one(vault)
            return created_vault
        end

        delete ':id' do
            vaults_repository = VaultsRepository.new
            deleted_count = vaults_repository.delete_one({ id: params[:id]})
            if(deleted_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no vault has been deleted.'}
            end
        end
        
        params do
            requires :last_modifier_user_id, type: Integer
        end
        patch ':id' do
            patch = Hash.new
            patch[:name] = params[:name] if params[:name] != nil
            patch[:amount] = params[:amount] if params[:amount] != nil
            patch[:type] = params[:type] if params[:type] != nil
            patch[:style] = params[:style] if params[:style] != nil
            patch[:details] = params[:details] if params[:details] != nil
            patch[:owner_user_id] = params[:owner_user_id] if params[:owner_user_id] != nil
            patch[:last_modifier_user_id] = params[:last_modifier_user_id] if params[:last_modifier_user_id] != nil
            vaults_repository = VaultsRepository.new
            modified_count = vaults_repository.patch_one({ id: params[:id]}, patch)
            if(modified_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no vault has been patched.'}
            end
        end
        
        params do
            requires :name, type: String
            requires :type, type: String
            requires :owner_user_id, type: Integer
            requires :last_modifier_user_id, type: Integer
            optional :amount, type: Float, default: 0
        end
        put ':id' do
            vault = Vault.new
            vault.name = params[:name]
            vault.amount = params[:amount]
            vault.type = params[:type]
            vault.style = params[:style]
            vault.details = params[:details]
            vault.owner_user_id = params[:owner_user_id]
            vault.last_modifier_user_id = params[:last_modifier_user_id]
            vaults_repository = VaultsRepository.new
            modified_count = vaults_repository.update_one({ id: params[:id]}, vault.to_hash)
            if(modified_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no vault has been updated.'}
            end
        end
    end
end