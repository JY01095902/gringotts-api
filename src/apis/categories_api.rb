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
            categories = categories_repository.find params
            
            return CategoriesAPI.to_hypermedia(categories)
        end

        get ':id' do
            categories_repository = CategoriesRepository.new
            categories = categories_repository.find({ id: params[:id]})

            if categories.length > 0
                category = categories[0]

                return CategoriesAPI.to_hypermedia(category)
            else
                status 404
                return 'The resource is not found.'
            end
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
            created_category = categories_repository.insert_one category
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
        
        params do
            requires :last_modifier_user_id, type: Integer
        end
        patch ':id' do
            patch = Hash.new
            patch[:name] = params[:name] if params[:name] != nil
            patch[:type] = params[:type] if params[:type] != nil
            patch[:owner_user_id] = params[:owner_user_id] if params[:owner_user_id] != nil
            patch[:last_modifier_user_id] = params[:last_modifier_user_id] if params[:last_modifier_user_id] != nil
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
            requires :owner_user_id, type: Integer
            requires :last_modifier_user_id, type: Integer
        end
        put ':id' do
            category = Category.new
            category.name = params[:name]
            category.type = params[:type]
            category.owner_user_id = params[:owner_user_id]
            category.last_modifier_user_id = params[:last_modifier_user_id]
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

        def CategoriesAPI.to_hypermedia(resource)
            if(resource.kind_of? Hash)
                selfUrl = "serviceRoot/$metadata#categories/#{resource[:id]}"
                return Hash[
                    :@id => selfUrl, 
                    :@edit_link => selfUrl, 
                    :id => resource[:id], 
                    :name => resource[:name], 
                    :type => resource[:type]
                ]
            elsif(resource.kind_of? Array)
                categories = Hash[:@context => 'serviceRoot/$metadata#categories', :value => Array.new]
                resource.each do |category|
                    selfUrl = "serviceRoot/$metadata#categories/#{category[:id]}"
                    categories[:value] << Hash[
                        :@id => selfUrl, 
                        :@edit_link => selfUrl, 
                        :id => category[:id], 
                        :name => category[:name], 
                        :type => category[:type]
                    ]
                end
                return categories
            else
                return resource
            end
        end
    end
end