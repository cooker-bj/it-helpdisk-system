TaskTracingSystem::Application.routes.draw do
 resources :mywirelesses,:only=>['index','new','create','show']
 resources :callcenters,:only=>['index',"new","create"]
  post "callcenters/get_user"=>'callcenters#get_user'
  get "query" =>'query#index'
  post "query/query"
  match "summary" =>"summary#index"
  post "summary/index"
  match "summary/monthly_graph"=>"summary#monthly_graph"
  match  "summary/weekly_graph"
  match "summary/type_graph"
  match "summary/workload_graph"
  match "summary/waitting_graph"
  match "summary/workon_by_type_graph"
  match "summary/workon_by_staff_graph"
  match "summary/rank_graph"
  match "summary/rank_by_staff_graph"
  match "summary/callin_graph"
  resources :managements

  get "monitor" =>"monitor#index"
  get "monitor/list_not_taken_cases"
  get "monitor/list_more_hours_cases"
  get "monitor/list_working_cases"
  get "monitor/list_worked_more_days_cases"

  post 'mytasks/upgrade',:to=>'mytasks#upgrade'
  post 'mytasks/new',:to=>'mytasks#new'
  match 'mytasks/finished_tasks',:to=>"mytasks#finished_tasks"
  match "mytasks/verify_name"=> "mytasks#verify_name"
  resources :mytasks
#  resources :tasks
  resources :mycases
  match 'comment/:id' =>"mycases#edit_comment", :as=>'comment'
  match 'closed_cases',:to=>"mycases#closed_cases",:as=>'closed_cases'
  resource :sessions, :only=>['new','create','destroy']
  match '/signin' ,:to =>'sessions#new'
  match  '/signout',:to=>'sessions#destroy'


#  resources :it_cases

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'mycases#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
