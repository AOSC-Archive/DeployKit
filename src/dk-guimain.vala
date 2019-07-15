namespace Dk {
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

    /* Main Switching Stack */
    [GtkChild]
    private Gtk.Stack stack_main;

    /* Widgets in Page 1 (Prepare) */
    [GtkChild]
    private Gtk.Box box_prepare;

    /* Widgets in Page 2 (Recipe (General)) */
    [GtkChild]
    private Gtk.Box     box_recipe_general;
    [GtkChild]
    private Gtk.Label   label_recipe_general_variants_desc;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_general_variants;
    [GtkChild]
    private Gtk.Label   label_recipe_general_dest_desc;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_general_dest;
    [GtkChild]
    private Gtk.Label   label_recipe_general_repo_desc;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_general_repo;
    [GtkChild]
    private Gtk.Label   label_recipe_general_extra_components_desc;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_general_extra_components;
    [GtkChild]
    private Gtk.Entry   entry_recipe_general_hostname;
    [GtkChild]
    private Gtk.Entry   entry_recipe_general_locale;
    [GtkChild]
    private Gtk.Entry   entry_recipe_general_root_password;
    [GtkChild]
    private Gtk.Entry   entry_recipe_general_admin_username;
    [GtkChild]
    private Gtk.Entry   entry_recipe_general_admin_password;
    [GtkChild]
    private Gtk.Entry   entry_recipe_general_admin_password_retype;

    /* Widgets in Page 3 (Recipe (Expert)) */
    [GtkChild]
    private Gtk.Box     box_recipe_expert;
    [GtkChild]
    private Gtk.Label   label_recipe_expert_biy_desc;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_expert_biy;
    [GtkChild]
    private Gtk.Label   label_recipe_expert_dest_desc;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_expert_dest;
    [GtkChild]
    private Gtk.Label   label_recipe_expert_repo_desc;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_expert_repo;
    [GtkChild]
    private Gtk.Label   label_recipe_expert_extra_components_desc;
    [GtkChild]
    private Gtk.ListBox listbox_recipe_expert_extra_components;
    [GtkChild]
    private Gtk.Entry   entry_recipe_expert_hostname;
    [GtkChild]
    private Gtk.Entry   entry_recipe_expert_locale;
    [GtkChild]
    private Gtk.Entry   entry_recipe_expert_root_password;
    [GtkChild]
    private Gtk.Entry   entry_recipe_expert_admin_username;
    [GtkChild]
    private Gtk.Entry   entry_recipe_expert_admin_password;
    [GtkChild]
    private Gtk.Entry   entry_recipe_expert_admin_password_retype;

    /* Widgets in Page 4 (Installation) */
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

    /* Widgets in Page 5 (Done) */
    [GtkChild]
    private Gtk.Box box_done;

    /* Variables to use */
    private string proxy_type;
    private string proxy_address;
    private string proxy_port;
    private string proxy_username;
    private string proxy_password;

    public GuiMain() {
      // Load CSS from resource to override styles of some widgets
      var css_provider = new Gtk.CssProvider();
      css_provider.load_from_resource("/io/aosc/DeployKit/ui/dk-gui.css");
      Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    [GtkCallback]
    private void box_prepare_map_cb() {
      this.headerbar_main.set_title("Preparing");
      this.togglebtn_expert.set_visible(false);
      this.btn_network.set_visible(true);
      this.btn_ok.set_visible(false);
    }

    [GtkCallback]
    private void box_recipe_general_map_cb() {
      this.headerbar_main.set_title("Recipe");
      this.togglebtn_expert.set_visible(true);
      this.btn_network.set_visible(true);
      this.btn_ok.set_visible(true);
    }

    [GtkCallback]
    private void box_recipe_expert_map_cb() {
      this.headerbar_main.set_title("Recipe");
      this.togglebtn_expert.set_visible(true);
      this.btn_network.set_visible(true);
      this.btn_ok.set_visible(true);
    }

    [GtkCallback]
    private void box_install_map_cb() {
      this.headerbar_main.set_title("Installing");
      this.togglebtn_expert.set_visible(false);
      this.btn_network.set_visible(false);
      this.btn_ok.set_visible(false);
    }

    [GtkCallback]
    private void box_done_map_cb() {
      this.headerbar_main.set_title("Done");
      this.togglebtn_expert.set_visible(false);
      this.btn_network.set_visible(false);
      this.btn_ok.set_visible(false);
    }

    [GtkCallback]
    private void togglebtn_expert_toggled_cb() {
      if (this.togglebtn_expert.get_active())
        this.stack_main.set_visible_child(this.box_recipe_expert);
      else
        this.stack_main.set_visible_child(this.box_recipe_general);
    }

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

    [GtkCallback]
    private void btn_network_clicked_cb() {
      var network_config_dialog = new Dk.NetworkConfig((type, addr, port, username, password) => {
        if (type == null)
          this.proxy_type = "Disable";
        else
          this.proxy_type = type;

        if (addr == "")
          this.proxy_address = null;
        else
          this.proxy_address = addr;

        if (port == "")
          this.proxy_port = null;
        else
          this.proxy_port = port;

        if (username == "")
          this.proxy_username = null;
        else
          this.proxy_username = username;

        if (password == "")
          this.proxy_password = null;
        else
          this.proxy_password = password;

        var ctx = this.btn_network.get_style_context();

        if (this.proxy_type != null && this.proxy_type != "Disable" &&
            this.proxy_address != null &&
            this.proxy_port != null)
        {
          // Highlight the button to indicate that the proxy has been set
          ctx.add_class("suggested-action");
        } else {
          if (ctx.has_class("suggested-action")) {
            ctx.remove_class("suggested-action");
          }
        }
      });

      // Set modal dialog transient for the main window
      network_config_dialog.set_transient_for(this);
      network_config_dialog.show_all();
    }
  }
}
