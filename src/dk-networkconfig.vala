namespace Dk {
  public delegate void NetworkConfigCallback(string proxy_type, string proxy_address, string proxy_port, string proxy_username, string proxy_password);

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

    private NetworkConfigCallback callback_save;

    public NetworkConfig(NetworkConfigCallback cb) {
      this.callback_save = cb;
    }

    [GtkCallback]
    private void btn_done_clicked_cb() {
      this.callback_save(
        this.proxy_type.get_active_text(),
        this.address.get_text(),
        this.port.get_text(),
        this.port.get_text(),
        this.password.get_text()
      );

      this.destroy();
    }
  }
}
