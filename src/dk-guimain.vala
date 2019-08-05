namespace Dk {
  private errordomain LoadRecipeError {
    PARSE_ERROR,
    UNKNOWN_VERSION,
  }

  /**
   * The main application window of DeployKit.
   */
  [GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-guimain.ui")]
  public class GuiMain : Gtk.ApplicationWindow {
    /* Widgets in Header Bar */
    [GtkChild]
    private Gtk.HeaderBar headerbar_main;
    [GtkChild]
    private Gtk.ToggleButton togglebtn_expert;
    [GtkChild]
    private Gtk.Button btn_ok;
    [GtkChild]
    private Gtk.Button btn_network;

    /* Bulletin */
    [GtkChild]
    private Gtk.Revealer revealer_bulletin;
    [GtkChild]
    private Gtk.InfoBar infobar_bulletin;
    [GtkChild]
    private Gtk.Label label_bulletin_title;
    [GtkChild]
    private Gtk.Label label_bulletin_body;

    /* Main Switching Stack */
    [GtkChild]
    private Gtk.Stack stack_main;

    /* ========== Widgets in Page 1 (Prepare) ========== */
    [GtkChild]
    private Gtk.Box box_prepare;

    /* ========== Widgets in Page 2 (Recipe (General)) ========== */
    [GtkChild]
    private Gtk.Box box_recipe_general;

    /* Variant */
    [GtkChild]
    private Gtk.Button  btn_recipe_general_variant_clear;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_general_variant;

    /* Destination */
    [GtkChild]
    private Gtk.Button  btn_recipe_general_dest_refresh;
    [GtkChild]
    private Gtk.Button  btn_recipe_general_dest_clear;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_general_dest;
    [GtkChild]
    private Gtk.Button  btn_recipe_general_dest_partition;

    /* Mirror */
    [GtkChild]
    private Gtk.Button  btn_recipe_general_mirror_clear;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_general_mirror;

    /* Extra Components */
    [GtkChild]
    private Gtk.Button  btn_recipe_general_xcomps_clear;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_general_xcomps;

    /* System Configuration */
    [GtkChild]
    private Gtk.Entry entry_recipe_general_hostname;
    [GtkChild]
    private Gtk.Entry entry_recipe_general_locale;
    [GtkChild]
    private Gtk.Entry entry_recipe_general_root_password;
    [GtkChild]
    private Gtk.Entry entry_recipe_general_admin_username;
    [GtkChild]
    private Gtk.Entry entry_recipe_general_admin_password;
    [GtkChild]
    private Gtk.Entry entry_recipe_general_admin_password_retype;

    /* ========== Widgets in Page 3 (Recipe (Expert)) ========== */
    [GtkChild]
    private Gtk.Box     box_recipe_expert;

    /* Build-It-Yourself */
    [GtkChild]
    private Gtk.Button  btn_recipe_expert_biy_clear;
    [GtkChild]
    private Gtk.Button  btn_recipe_expert_biy_add;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_expert_biy;

    /* Extra Components */
    [GtkChild]
    private Gtk.Button  btn_recipe_expert_xcomps_clear;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_expert_xcomps;

    /* Destination */
    [GtkChild]
    private Gtk.Button  btn_recipe_expert_dest_clear;
    [GtkChild]
    private Gtk.Button  btn_recipe_expert_dest_refresh;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_expert_dest;
    [GtkChild]
    private Gtk.Button  btn_recipe_expert_dest_partition;

    /* Mirror */
    [GtkChild]
    private Gtk.Button  btn_recipe_expert_mirror_clear;
    [GtkChild]
    private Gtk.Button  btn_recipe_expert_mirror_add;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_expert_mirror;

    /* System Configuration */
    [GtkChild]
    private Gtk.Entry entry_recipe_expert_hostname;
    [GtkChild]
    private Gtk.Entry entry_recipe_expert_locale;
    [GtkChild]
    private Gtk.Entry entry_recipe_expert_root_password;
    [GtkChild]
    private Gtk.Entry entry_recipe_expert_admin_username;
    [GtkChild]
    private Gtk.Entry entry_recipe_expert_admin_password;
    [GtkChild]
    private Gtk.Entry entry_recipe_expert_admin_password_retype;

    /* ========== Widgets in Page 4 (Installation) ========== */
    [GtkChild]
    private Gtk.Box   box_install;
    [GtkChild]
    private Gtk.Stack stack_installation_ad;
    [GtkChild]
    private Gtk.Label label_installation_step_curr;
    [GtkChild]
    private Gtk.Label label_installation_step_max;
    [GtkChild]
    private Gtk.Label label_installation_step_desc;
    [GtkChild]
    private Gtk.ProgressBar progressbar_installation;

    /* ========== Widgets in Page 5 (Done) ========== */
    [GtkChild]
    private Gtk.Box box_done;

    /* ========== Variables to Use ========== */
    private ProxyType? proxy_type;
    private string? proxy_address;
    private string? proxy_port;
    private string? proxy_username;
    private string? proxy_password;

    private GLib.File? local_recipe;
    private string root_url = "https://repo.aosc.io";

    /**
     * Constructor for ``Dk.GuiMain``.
     */
    public GuiMain() {
      // Load CSS from resource to override styles of some widgets
      var css_provider = new Gtk.CssProvider();
      css_provider.load_from_resource("/io/aosc/DeployKit/ui/dk-gui.css");
      Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    /**
     * Callback on ``map`` event of ``Gtk.Box`` "Preparing".
     *
     * This function is called as the box shows up, so as to switch the content
     * in the header bar correspondingly.
     */
    [GtkCallback]
    private void box_prepare_map_cb() {
      this.headerbar_main.set_title("Preparing");
      this.togglebtn_expert.set_visible(false);
      this.btn_network.set_visible(true);
      this.btn_ok.set_visible(false);

      /*
       * If a recipe.json is given, use that file and do not fetch from the
       * Internet. This is useful for debugging.
       */
      if (this.local_recipe != null) {
        GLib.message("You are using a local recipe. This is only for debugging and advanced users' use; DO NOT USE IT if you don't know what you are doing!");

        uint8[] file_content;
        try {
          this.local_recipe.load_contents(null, out file_content, null);
        } catch (Error e) {
          var dlg = new Gtk.MessageDialog(
            this,
            DESTROY_WITH_PARENT | MODAL,
            ERROR,
            OK,
            "%s.\n\nPlease check again if the file is accessible.",
            e.message
          );
          dlg.run();
          dlg.destroy();

          GLib.Process.exit(2);
        }

        /*
         * Load recipe from the specified file.
         */
        try {
          this.load_recipe((string)file_content);
        } catch (LoadRecipeError e) {
          var dlg = new Gtk.MessageDialog(
            this,
            DESTROY_WITH_PARENT | MODAL,
            ERROR,
            OK,
            "Failed to load the specified recipe at %s: %s.\n\nPlease check again if the content of file is valid.",
            this.local_recipe.get_parse_name(),
            e.message
          );
          dlg.run();
          dlg.destroy();

          GLib.Process.exit(1);
        }

        /* Switch to the recipe (general) page. */
        this.stack_main.set_visible_child(this.box_recipe_general);

        return;
      }

      /*
       * If no local recipe is given, fetch one online.
       *
       * After the thread below is created, the signal handler returns. When
       * data arrives the thread will tell GLib to call a lambda function in the
       * main thread to update GUI (to switch to the recipe page).
       */
      new GLib.Thread<bool>("fetch_recipe", () => {
        var session = new Soup.Session();
        var baseuri = new Soup.URI(this.root_url);
        var httpuri = new Soup.URI.with_base(baseuri, "/aosc-os/recipe.json");
        var httpmsg = new Soup.Message.from_uri("GET", httpuri);

        var status = session.send_message(httpmsg);

        if (status != Soup.Status.OK) {
          GLib.Idle.add(() => {
            /* TODO: Service unavailable, switch to offline mode */

            /* Switch to the recipe (general) page. */
            this.stack_main.set_visible_child(this.box_recipe_general);

            /* Give a message to the user about what happened */
            var dlg = new Gtk.MessageDialog(
              this,
              DESTROY_WITH_PARENT | MODAL,
              ERROR,
              OK,
              "You are now in offline mode because it looks like the service is temporary unavailable (error code %u).\n\nPlease check your network connection. If necessary, use the provided network settings, and try again. If you believe that your network connection has nothing wrong, then we might get something wrong. Please report to us.",
              status
            );
            dlg.run();
            dlg.destroy();

            return false;
          });

          /* Don't continue execution */
          return false;
        }

        /* Parse the returned content to a recipe */
        var http_content = (string)httpmsg.response_body.data;

        // Once fetched, go back to the main thread to refresh GUI
        GLib.Idle.add(() => {
          /*
           * All processes above successfully finished, enter online mode.
           */
          try {
            this.load_recipe(http_content);
          } catch (LoadRecipeError e) {
            var dlg = new Gtk.MessageDialog(
              this,
              DESTROY_WITH_PARENT | MODAL,
              ERROR,
              OK,
              "Failed to load the fetched recipe: %s.\n\nPlease report this incident to us.",
              e.message
            );
            dlg.run();
            dlg.destroy();

            GLib.Process.exit(1);
          }

          /* Switch to the recipe (general) page. */
          this.stack_main.set_visible_child(this.box_recipe_general);

          /* Tell GLib not to call the function again. */
          return false;
        });

        return true;
      });
    }

    /**
     * Callback on ``map`` event of ``Gtk.Box`` "Recipe (General)".
     *
     * This function is called as the box shows up, so as to switch the content
     * in the header bar correspondingly.
     */
    [GtkCallback]
    private void box_recipe_general_map_cb() {
      this.headerbar_main.set_title("Recipe");
      this.togglebtn_expert.set_visible(true);
      this.btn_network.set_visible(true);
      this.btn_ok.set_visible(true);
    }

    /**
     * Callback on ``map`` event of ``Gtk.Box`` "Recipe (Expert)".
     *
     * This function is called as the box shows up, so as to switch the content
     * in the header bar correspondingly.
     */
    [GtkCallback]
    private void box_recipe_expert_map_cb() {
      this.headerbar_main.set_title("Recipe");
      this.togglebtn_expert.set_visible(true);
      this.btn_network.set_visible(true);
      this.btn_ok.set_visible(true);
    }

    /**
     * Callback on ``map`` event of ``Gtk.Box`` "Installing".
     *
     * This function is called as the box shows up, so as to switch the content
     * in the header bar correspondingly.
     */
    [GtkCallback]
    private void box_install_map_cb() {
      this.headerbar_main.set_title("Installing");
      this.togglebtn_expert.set_visible(false);
      this.btn_network.set_visible(false);
      this.btn_ok.set_visible(false);
    }

    /**
     * Callback on ``map`` event of ``Gtk.Box`` "Done".
     *
     * This function is called as the box shows up, so as to switch the content
     * in the header bar correspondingly.
     */
    [GtkCallback]
    private void box_done_map_cb() {
      this.headerbar_main.set_title("Done");
      this.togglebtn_expert.set_visible(false);
      this.btn_network.set_visible(false);
      this.btn_ok.set_visible(false);
    }

    /**
     * Callback on ``toggled`` event of the toggle-button "Expert".
     *
     * When the button is toggled, the interface should switch to the "expert"
     * recipe for the user to perform advanced installation.
     */
    [GtkCallback]
    private void togglebtn_expert_toggled_cb() {
      if (this.togglebtn_expert.get_active())
        this.stack_main.set_visible_child(this.box_recipe_expert);
      else
        this.stack_main.set_visible_child(this.box_recipe_general);
    }

    /**
     * Callback on ``clicked`` event of the button "OK".
     *
     * When the button is clicked, installation should take place according to
     * what the user selects in the recipe.
     */
    [GtkCallback]
    private void btn_ok_clicked_cb() {
      var visible_child = this.stack_main.get_visible_child();
      if (visible_child == this.box_recipe_general ||
          visible_child == this.box_recipe_expert)
      {
        // TODO: Proceed with installation
        // 1. Store configuration into config store
        // 2. Switch to installation page
        // 3. Spawn IR generator to create config for the backend
        // 4. Spawn the backend, bind status RPC messages to widgets
        this.label_installation_step_curr.set_text("1");
        this.label_installation_step_max.set_text("8");
        this.label_installation_step_desc.set_text("Preparing for installation");
        this.stack_main.set_visible_child(this.box_install);
      } else {
        // The button is unexpectedly clicked when it should not be shown
      }
    }

    /**
     * Callback on ``clicked`` event of button "Network Config".
     *
     * When the button is clicked, a network configuation dialog should show up
     * for the user to configure their suitable network setup, e.g. proxies, or
     * offline.
     */
    [GtkCallback]
    private void btn_network_clicked_cb() {
      var network_config_dialog = new Dk.NetworkConfig(
        this.proxy_type,
        this.proxy_address,
        this.proxy_port,
        this.proxy_username,
        this.proxy_password,
        (type, addr, port, username, password) => {
          this.proxy_type     = type;
          this.proxy_address  = addr;
          this.proxy_port     = port;
          this.proxy_username = username;
          this.proxy_password = password;

          // Highlight the button to indicate that the proxy has been set
          var ctx = this.btn_network.get_style_context();

          if (this.proxy_type != ProxyType.DISABLE &&
              this.proxy_address != null &&
              this.proxy_port != null)
          {
            ctx.add_class("suggested-action");
          } else {
            if (ctx.has_class("suggested-action")) {
              ctx.remove_class("suggested-action");
            }
          }
        }
      );

      // Set modal dialog transient for the main window
      network_config_dialog.set_transient_for(this);
      network_config_dialog.show_all();
    }

    [GtkCallback]
    private void infobar_bulletin_response_cb(int response_id) {
      if (response_id == Gtk.ResponseType.CANCEL ||
          response_id == Gtk.ResponseType.CLOSE)
      {
        /*
         * Either the close button is clicked or Esc is pressed.
         *
         * I still don't know why after GtkInfoBar reveals itself, there is
         * still an annoying 1px line displaying. Look how nice a GtkRevealer
         * does.
         */
        this.revealer_bulletin.set_reveal_child(false);
      }
    }

    /**
     * Load a recipe.json string into GUI.
     *
     * @param recipe_str A JSON string representing a recipe object.
     */
    private void load_recipe(string recipe_str) throws LoadRecipeError {
      var recipe = new Dk.Recipe.Recipe();
      bool r = recipe.from_json_string(recipe_str);
      if (!r)
        throw new LoadRecipeError.PARSE_ERROR("The recipe is invalid and cannot be parsed");

      /* NOTE: Parsing version 0 recipe. */
      if (recipe.get_version() != 0)
        throw new LoadRecipeError.UNKNOWN_VERSION("Recipe version %d is not supported", recipe.get_version());

      /* Bulletin */
      var bulletin = recipe.get_bulletin();
      if (bulletin.get_bulletin_type() != "unknown" &&
          bulletin.get_bulletin_type() != "none")
      {
        var title = bulletin.get_title();
        var body  = bulletin.get_body();

        if (title != null)
          this.label_bulletin_title.set_text(title);
        if (body != null)
          this.label_bulletin_body.set_text(body);

        /* Reveal only when something is to be shown */
        if (!(title == null && body == null))
          this.revealer_bulletin.set_reveal_child(true);
      }

      /* Variants */
      recipe.get_variants().foreach((v) => {
        /* XXX: Only the newest tarball is shown. Need to design a way to display all. */
        var tarball_newest = v.get_tarball_newest();

        this.listbox_recipe_general_variant.add(
          new VariantRow(
            "package-x-generic-symbolic",
            v.get_name(),
            tarball_newest.get_date().format("%x"),
            tarball_newest.get_download_size(),
            tarball_newest.get_installation_size()
          )
        );
        this.listbox_recipe_expert_biy.add(
          new VariantRow(
            "package-x-generic-symbolic",
            v.get_name(),
            tarball_newest.get_date().format("%x"),
            tarball_newest.get_download_size(),
            tarball_newest.get_installation_size()
          )
        );

        return true;
      });

      /* Mirrors */
      recipe.get_mirrors().foreach((m) => {
        this.listbox_recipe_general_mirror.add(
          new MirrorRow(
            "package-x-generic-symbolic",
            m.get_name_l10n(Dk.Utils.get_lang()) ?? m.get_name(),
            m.get_location_l10n(Dk.Utils.get_lang()) ?? m.get_location()
          )
        );
        this.listbox_recipe_expert_mirror.add(
          new MirrorRow(
            "package-x-generic-symbolic",
            m.get_name_l10n(Dk.Utils.get_lang()) ?? m.get_name(),
            m.get_location_l10n(Dk.Utils.get_lang()) ?? m.get_location()
          )
        );

        return true;
      });

      /* TODO: Extra Components */
    }

    public GLib.File get_local_recipe() {
      return this.local_recipe;
    }

    public void set_local_recipe(GLib.File recipe) {
      this.local_recipe = recipe;
    }

    public string get_root_url() {
      return this.root_url;
    }

    public void set_root_url(string url) {
      this.root_url = url;
    }
  }
}
