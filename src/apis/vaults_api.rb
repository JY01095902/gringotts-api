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
    end
end