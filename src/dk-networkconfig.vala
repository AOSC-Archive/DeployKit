namespace Dk {
  [GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-networkconfig.ui")]
  public class NetworkConfig : Gtk.Window {
    [GtkChild (name = "btn_done")]
    private Gtk.Button done;
    [GtkChild (name = "combobox_type")]
    private Gtk.ComboBoxText proxy_type;
    [GtkChild (name = "entry_addr")]
    private Gtk.Entry address;
    [GtkChild (name = "entry_port")]
    private Gtk.Entry port;
    [GtkChild (name = "entry_username")]
    private Gtk.Entry username;
    [GtkChild (name = "entry_password")]
    private Gtk.Entry password;

    public NetworkConfig() {}
  }
}
