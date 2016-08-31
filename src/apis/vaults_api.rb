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
            vaults = vaults_repository.find
            return vaults
        end

        get ':id' do
            vaults_repository = VaultsRepository.new
            vaults = vaults_repository.find({ id: params[:id]})
            return vaults
        end

        params do
            requires :name, type: String
            requires :account_id, type: String
            optional :amount, type: Float, default: 0
        end
        post do
            vault = Vault.new
            vault.name = params[:name]
            vault.amount = params[:amount]
            vault.account_id = params[:account_id]
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
        
        patch ':id' do
            patch = Hash.new
            patch[:name] = params[:name] if params[:name] != nil
            patch[:amount] = params[:amount] if params[:amount] != nil
            patch[:account_id] = params[:account_id] if params[:account_id] != nil
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
            requires :account_id, type: String
            optional :amount, type: Float, default: 0
        end
        put ':id' do
            vault = Vault.new
            vault.name = params[:name]
            vault.amount = params[:amount]
            vault.account_id = params[:account_id]
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