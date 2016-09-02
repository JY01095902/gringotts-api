$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'repositories'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'grape'
require 'chests_repository'
require 'chest'

class ChestsAPI < Grape::API
    version 'v1'
    prefix :api
    format :json
    resources :chests do
        get do
            chests_repository = ChestsRepository.new
            chests = chests_repository.find
            return chests
        end

        get ':id' do
            chests_repository = ChestsRepository.new
            chests = chests_repository.find({ id: params[:id]})
            return chests
        end

        params do
            requires :name, type: String
            requires :vault_id, type: String
            optional :amount, type: Float, default: 0
        end
        post do
            chest = Chest.new
            chest.name = params[:name]
            chest.amount = params[:amount]
            chest.vault_id = params[:vault_id]
            chests_repository = ChestsRepository.new
            created_chest = chests_repository.insert_one(chest)
            return created_chest
        end

        delete ':id' do
            chests_repository = ChestsRepository.new
            deleted_count = chests_repository.delete_one({ id: params[:id]})
            if(deleted_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no chest has been deleted.'}
            end
        end
        
        patch ':id' do
            patch = Hash.new
            patch[:name] = params[:name] if params[:name] != nil
            patch[:amount] = params[:amount] if params[:amount] != nil
            patch[:vault_id] = params[:vault_id] if params[:vault_id] != nil
            chests_repository = ChestsRepository.new
            modified_count = chests_repository.patch_one({ id: params[:id]}, patch)
            if(modified_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no chest has been patched.'}
            end
        end
        
        params do
            requires :name, type: String
            requires :vault_id, type: String
            optional :amount, type: Float, default: 0
        end
        put ':id' do
            chest = Chest.new
            chest.name = params[:name]
            chest.amount = params[:amount]
            chest.vault_id = params[:vault_id]
            chests_repository = ChestsRepository.new
            modified_count = chests_repository.update_one({ id: params[:id]}, chest.to_hash)
            if(modified_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no chest has been updated.'}
            end
        end
    end
end