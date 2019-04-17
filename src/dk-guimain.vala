namespace Dk {
  [GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-guimain.ui")]
  public class GuiMain : Gtk.ApplicationWindow {
    /* The application */
    private Gtk.Application app;

    /* Widgets in Header Bar */
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

    public GuiMain(Gtk.Application app) {
      new Gtk.ApplicationWindow(app);

      // Save the application for destruction
      this.app = app;
    }

    ~GuiMain() {
      // Quit the program when window is closed
      this.app.release();
    }
  }
}