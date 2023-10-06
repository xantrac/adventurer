defmodule AdventurerWeb.Router do
  use AdventurerWeb, :router

  import AdventurerWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AdventurerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :graphql do
    plug(:fetch_session)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
    plug(AdventurerWeb.Context)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:adventurer, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AdventurerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/graphql" do
    pipe_through(:graphql)

    forward("/", Absinthe.Plug, schema: AdventurerWeb.Schema)
  end

  ## Authentication routes

  scope "/", AdventurerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{AdventurerWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", AdventurerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [
        {AdventurerWeb.UserAuth, :ensure_authenticated},
        {AdventurerWeb.Path, :put_path_in_socket}
      ] do
      scope "/my" do
        live "/stories/new", Author.StoryLive.Index, :new
        live("/stories/:id", Author.StoryLive.Show, :show)
        live("/stories/:id/nodes", Author.NodeEditorLive, :edit)
        live "/stories/:id/preview", Author.StoryLive.Show, :preview
        live "/stories/:id/preview/nodes/:node_id", Author.StoryLive.Show, :preview
        live "/stories/:id/nodes/new", NodeLive.New, :new
        live("/stories/:id/nodes/:node_id", Author.NodeEditorLive, :edit)
        live "/stories/:id/nodes/:node_id/choices/new", NodeLive.Show, :new_choice
        live "/users/settings", UserSettingsLive, :edit
        live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
        live "/stories", Author.StoryLive.Index, :index
      end
    end
  end

  scope "/", AdventurerWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [
        {AdventurerWeb.UserAuth, :mount_current_user},
        {AdventurerWeb.Path, :put_path_in_socket}
      ] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new

      live "/stories/:id/preview", StoryLive.Preview, :show
      live "/", StoryLive.Index, :index
    end
  end
end
