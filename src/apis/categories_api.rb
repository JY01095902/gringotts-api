$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'repositories'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'entities'))

require 'grape'
require 'categories_repository'
require 'category'

class CategoriesAPI < Grape::API
    version 'v1'
    prefix :api
    format :json
    resources :categories do
        get do
            categories_repository = CategoriesRepository.new
            categories = categories_repository.find
            return categories
        end

        get ':id' do
            categories_repository = CategoriesRepository.new
            categories = categories_repository.find({ id: params[:id]})
            return categories
        end

        params do
            requires :name, type: String
            requires :type, type: String
        end
        post do
            category = Category.new
            category.name = params[:name]
            category.type = params[:type]
            categories_repository = CategoriesRepository.new
            created_category = categories_repository.insert_one(category)
            return created_category
        end

        delete ':id' do
            categories_repository = CategoriesRepository.new
            deleted_count = categories_repository.delete_one({ id: params[:id]})
            if(deleted_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no category has been deleted.'}
            end
        end
        
        patch ':id' do
            patch = Hash.new
            patch[:name] = params[:name] if params[:name] != nil
            patch[:type] = params[:type] if params[:type] != nil
            categories_repository = CategoriesRepository.new
            modified_count = categories_repository.patch_one({ id: params[:id]}, patch)
            if(modified_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no category has been patched.'}
            end
        end
        
        params do
            requires :name, type: String
            requires :type, type: String
        end
        put ':id' do
            category = Category.new
            category.name = params[:name]
            category.type = params[:type]
            categories_repository = CategoriesRepository.new
            modified_count = categories_repository.update_one({ id: params[:id]}, category.to_hash)
            if(modified_count == 1)
                status 204
                return String.new
            else
                status 404
                return { message: 'no category has been updated.'}
            end
        end
    end
end