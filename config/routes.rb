Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :aplicacoes, only: [ :index, :show ] do
        collection do
          get :estatisticas
          get :candidatas
        end
      end

      resources :dependencias, only: [ :index ]

      # SAURON - Módulos internos (API)
      resources :sauron_modulos, only: [ :index, :show ] do
        collection do
          get :estatisticas
          get :riscos
          get :dependencias_criticas
        end

        member do
          get :dependencias
        end
      end
      resources :scan_results, only: [ :index, :show ]
      get "scan",     to: "scan_results#index"
      get "scan/:id", to: "scan_results#show"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
