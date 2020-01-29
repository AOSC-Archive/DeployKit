namespace Dk {
namespace Gui {

/**
 * Errors that may be thrown by ``load_recipe``.
 */
private errordomain LoadRecipeError {
  /** Parse error. */
  PARSE_ERROR,

  /** Unknown recipe version. */
  UNKNOWN_VERSION,
}

/**
 * The main application window of DeployKit.
 */
[GtkTemplate (ui = "/io/aosc/DeployKit/ui/main.ui")]
public class Main : Gtk.ApplicationWindow {
  /* Widgets in Header Bar */
  [GtkChild]
  private Gtk.HeaderBar headerbar_main;
  [GtkChild]
  private Gtk.ToggleButton togglebtn_expert;
  [GtkChild]
  private Gtk.Button btn_back;
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

  /* ========== Widgets in Page 4 (Confirm) ========== */
  [GtkChild]
  private Gtk.Box box_confirm;
  [GtkChild]
  private Gtk.Label label_confirm_variant;
  [GtkChild]
  private Gtk.Label label_confirm_dest;
  [GtkChild]
  private Gtk.Label label_confirm_mirror;
  [GtkChild]
  private Gtk.Label label_confirm_xcomps;
  [GtkChild]
  private Gtk.Label label_confirm_hostname;
  [GtkChild]
  private Gtk.Label label_confirm_locale;
  [GtkChild]
  private Gtk.Label label_confirm_admin_username;

  /* ========== Widgets in Page 5 (Installation) ========== */
  [GtkChild]
  private Gtk.Box   box_install;
  [GtkChild]
  private Gtk.Stack stack_installation_ad;
  [GtkChild]
  private Gtk.Label label_installation_step_curr;
  [GtkChild]
  private Gtk.Label label_installation_step_of;
  [GtkChild]
  private Gtk.Label label_installation_step_max;
  [GtkChild]
  private Gtk.Label label_installation_step_desc;
  [GtkChild]
  private Gtk.ProgressBar progressbar_installation;

  /* ========== Widgets in Page 6 (Done) ========== */
  [GtkChild]
  private Gtk.Box box_done;

  /* ========== Variables to Use ========== */
  private Gtk.Widget? last_page;

  private ProxyType? proxy_type;
  private string? proxy_address;
  private string? proxy_port;
  private string? proxy_username;
  private string? proxy_password;

  private GLib.File? local_recipe;
  private string root_url = "https://repo.aosc.io";

  private uint? progressbar_installation_event_source_id;

  /**
   * Constructor for ``Dk.Gui.Main``.
   */
  public Main() {
    /* Load CSS from resource to override styles of some widgets */
    var css_provider = new Gtk.CssProvider();
    css_provider.load_from_resource("/io/aosc/DeployKit/ui/gui.css");
    Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

    /* The default locale is the current locale */
    this.entry_recipe_general_locale.set_placeholder_text(GLib.Intl.setlocale());
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
    this.btn_back.set_visible(false);
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
          Gtk.DialogFlags.DESTROY_WITH_PARENT
            | Gtk.DialogFlags.MODAL
            | Gtk.DialogFlags.USE_HEADER_BAR,
          Gtk.MessageType.ERROR,
          Gtk.ButtonsType.OK,
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
          Gtk.DialogFlags.DESTROY_WITH_PARENT
            | Gtk.DialogFlags.MODAL
            | Gtk.DialogFlags.USE_HEADER_BAR,
          Gtk.MessageType.ERROR,
          Gtk.ButtonsType.OK,
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
            Gtk.DialogFlags.DESTROY_WITH_PARENT
              | Gtk.DialogFlags.MODAL
              | Gtk.DialogFlags.USE_HEADER_BAR,
            Gtk.MessageType.ERROR,
            Gtk.ButtonsType.OK,
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

      /* Once fetched, go back to the main thread to refresh GUI */
      GLib.Idle.add(() => {
        /*
         * All processes above successfully finished, enter online mode.
         */
        try {
          this.load_recipe(http_content);
        } catch (LoadRecipeError e) {
          var dlg = new Gtk.MessageDialog(
            this,
            Gtk.DialogFlags.DESTROY_WITH_PARENT
              | Gtk.DialogFlags.MODAL
              | Gtk.DialogFlags.USE_HEADER_BAR,
            Gtk.MessageType.ERROR,
            Gtk.ButtonsType.OK,
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
    this.btn_back.set_visible(false);
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
    this.btn_back.set_visible(false);
    this.btn_network.set_visible(true);
    this.btn_ok.set_visible(true);
  }

  /**
   * Callback on ``map`` event of ``Gtk.Box`` "Confirm".
   *
   * This function is called as the box shows up, so as to switch the content
   * in the header bar correspondingly.
   */
  [GtkCallback]
  private void box_confirm_map_cb() {
    this.headerbar_main.set_title("Confirm");
    this.togglebtn_expert.set_visible(false);
    this.btn_back.set_visible(true);
    this.btn_network.set_visible(true);
    this.btn_ok.set_visible(true);

    /* Collect recipe and display information for the user to confirm */
    Gtk.ListBoxRow? variant_row = null;
    Gtk.ListBoxRow? dest_row = null;
    Gtk.ListBoxRow? mirror_row = null;
    Gtk.ListBoxRow? xcomps_row = null;
    string? hostname = null;
    string? locale   = null;
    string? username = null;

    if (this.last_page == box_recipe_general) {
      variant_row = this.listbox_recipe_general_variant.get_selected_row();
      dest_row    = this.listbox_recipe_general_dest.get_selected_row();
      mirror_row  = this.listbox_recipe_general_mirror.get_selected_row();
      xcomps_row  = this.listbox_recipe_general_xcomps.get_selected_row();
      hostname    = this.entry_recipe_general_hostname.get_text();
      locale      = this.entry_recipe_general_locale.get_text();
      username    = this.entry_recipe_general_admin_username.get_text();
    } else if (this.last_page == box_recipe_expert) {
      variant_row = this.listbox_recipe_expert_biy.get_selected_row();
      dest_row    = this.listbox_recipe_expert_dest.get_selected_row();
      mirror_row  = this.listbox_recipe_expert_mirror.get_selected_row();
      xcomps_row  = this.listbox_recipe_expert_xcomps.get_selected_row();
      hostname    = this.entry_recipe_expert_hostname.get_text();
      locale      = this.entry_recipe_expert_locale.get_text();
      username    = this.entry_recipe_expert_admin_username.get_text();
    }

    this.label_confirm_variant.set_text(
      variant_row == null ?
      "Not selected" :
      ((Rows.Variant)variant_row.get_child()).get_variant_name()
    );

    this.label_confirm_dest.set_text(
      dest_row == null ?
      "Not selected" :
      ((Rows.Destination)dest_row.get_child()).get_destination_path()
    );

    this.label_confirm_mirror.set_text(
      mirror_row == null ?
      "Not selected" :
      ((Rows.Mirror)mirror_row.get_child()).get_mirror_name()
    );

    this.label_confirm_xcomps.set_text(
      xcomps_row == null ?
      "Not selected" :
      ((Rows.ExtraComponent)xcomps_row.get_child()).get_component_name()
    );

    this.label_confirm_hostname.set_text(
      (hostname == null || hostname == "") ? "Not set" : hostname
    );

    this.label_confirm_locale.set_text(
      (locale == null || locale == "") ? @"$(GLib.Intl.setlocale())" : locale
    );

    this.label_confirm_admin_username.set_text(
      (username == null || username == "") ? "Not set" : username
    );
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
    this.btn_back.set_visible(false);
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
    this.btn_back.set_visible(false);
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
   * Callback on ``clicked`` event of the button "Back".
   *
   * When the button is clicked, the interface should switch back to the last
   * page.
   */
  [GtkCallback]
  private void btn_back_clicked_cb() {
    if (this.last_page != null)
      this.stack_main.set_visible_child(this.last_page);
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
      /* Remember which recipe the user used */
      this.last_page = visible_child;

      this.stack_main.set_visible_child(this.box_confirm);
    } else if (visible_child == this.box_confirm) {
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
    var network_config_dialog = new Dk.Gui.NetworkConfig(
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

        /* Highlight the button to indicate that the proxy has been set */
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

    /* Set modal dialog transient for the main window */
    network_config_dialog.set_transient_for(this);
    network_config_dialog.show_all();
  }

  /**
   * Callback on ``response`` event of the bulletin banner.
   *
   * @param response_id The GTK response ID set in GUI definition.
   */
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
      var title = bulletin.get_title_l10n(Utils.get_lang()) ?? bulletin.get_title();
      var body  = bulletin.get_body_l10n(Utils.get_lang()) ?? bulletin.get_body();

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
      /* XXX: Only the newest tarball is shown. */
      var tarball_newest = v.get_tarball_newest();

      /*
       * NOTE: It is impossible to add a same widget to two different
       * containers, so for the two different recipe pages, two identical
       * "Variant" rows are allocated.
       */
      this.listbox_recipe_general_variant.add(
        new Rows.Variant(
          "package-x-generic-symbolic",
          v.get_name_l10n(Dk.Utils.get_lang()) ?? v.get_name(),
          tarball_newest.get_date(),
          tarball_newest.get_download_size(),
          tarball_newest.get_installation_size()
        )
      );
      this.listbox_recipe_expert_biy.add(
        new Rows.Variant(
          "package-x-generic-symbolic",
          v.get_name_l10n(Dk.Utils.get_lang()) ?? v.get_name(),
          tarball_newest.get_date(),
          tarball_newest.get_download_size(),
          tarball_newest.get_installation_size()
        )
      );

      return true;
    });

    /* Mirrors */
    recipe.get_mirrors().foreach((m) => {
      this.listbox_recipe_general_mirror.add(
        new Rows.Mirror(
          "package-x-generic-symbolic",
          m.get_name_l10n(Dk.Utils.get_lang()) ?? m.get_name(),
          m.get_location_l10n(Dk.Utils.get_lang()) ?? m.get_location()
        )
      );
      this.listbox_recipe_expert_mirror.add(
        new Rows.Mirror(
          "package-x-generic-symbolic",
          m.get_name_l10n(Dk.Utils.get_lang()) ?? m.get_name(),
          m.get_location_l10n(Dk.Utils.get_lang()) ?? m.get_location()
        )
      );

      return true;
    });

    /* TODO: Extra Components */
  }

  /**
   * Set the current step number and description in the installation page.
   *
   * @param step The current step number.
   * @param desc A description describing the current step.
   */
  private void step(int step, string desc) {
    this.label_installation_step_curr.set_text(@"$step");
    this.label_installation_step_desc.set_text(desc);
  }

  /**
   * Set the maximum step number in the installation page.
   *
   * Note that this does not prevent the current step number from exceeding this
   * maximum number; this is only for updating the GUI.
   *
   * @param max_steps The maximum step number.
   */
  private void set_max_steps(int max_steps) {
    this.label_installation_step_max.set_text(@"$max_steps");
  }

  /**
   * Show "of Y" in "Step X in Y" on the installation page.
   */
  private void show_max_steps() {
    this.label_installation_step_of.set_visible(true);
    this.label_installation_step_max.set_visible(true);
  }

  /**
   * Hide "of Y" in "Step X in Y" on the installation page.
   *
   * This is useful when the maximum step is unknown.
   */
  private void hide_max_steps() {
    this.label_installation_step_of.set_visible(false);
    this.label_installation_step_max.set_visible(false);
  }

  /**
   * Set the progress bar on the installation page.
   *
   * @param percent The percent of the progress bar (between 0 and 100). The
   *                special value -1 pulses the progress bar.
   */
  private void progress(int percent)
    requires (percent >= -1 && percent <= 100)
  {
    if (this.progressbar_installation_event_source_id != null) {
      GLib.Source.remove(this.progressbar_installation_event_source_id);
      this.progressbar_installation_event_source_id = null;
    }

    if (percent >= 0) {
      this.progressbar_installation.set_text(null);
      this.progressbar_installation.set_fraction(percent / 100.0);
    } else {
      this.progressbar_installation.set_text("Skating…");
      this.progressbar_installation_event_source_id = GLib.Timeout.add(300, () => {
        this.progressbar_installation.pulse();
        return true;
      });
    }
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

} /* namespace Gui */
} /* namespace Dk */
