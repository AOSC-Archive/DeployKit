namespace Dk {
  public enum ProxyType {
    DISABLE = 0,
    HTTP    = 1,
    HTTPS   = 2,
    SOCKS5  = 3,
  }

  public delegate void NetworkConfigCallback(ProxyType? proxy_type, string? proxy_address, string? proxy_port, string? proxy_username, string? proxy_password);

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

    public NetworkConfig(ProxyType? type, string? addr, string? port, string? username, string? password, NetworkConfigCallback cb) {
      if (type != null)
        this.proxy_type.set_active(type);
      if (addr != null)
        this.address.set_text(addr);
      if (port != null)
        this.port.set_text(port);
      if (username != null)
        this.username.set_text(username);
      if (password != null)
        this.password.set_text(password);

      this.callback_save = cb;
    }

    [GtkCallback]
    private void combobox_type_changed_cb() {
      if (this.proxy_type.get_active() == ProxyType.DISABLE) {
        this.address.set_sensitive(false);
        this.port.set_sensitive(false);
        this.username.set_sensitive(false);
        this.password.set_sensitive(false);
      } else {
        this.address.set_sensitive(true);
        this.port.set_sensitive(true);
        this.username.set_sensitive(true);
        this.password.set_sensitive(true);
      }

      this.address.set_text("");
      this.port.set_text("");
      this.username.set_text("");
      this.password.set_text("");
    }

    [GtkCallback]
    private void btn_done_clicked_cb() {
      ProxyType? type = null;
      switch (this.proxy_type.get_active()) {
        case 1:
          type = ProxyType.HTTP;
          break;
        case 2:
          type = ProxyType.HTTPS;
          break;
        case 3:
          type = ProxyType.SOCKS5;
          break;
        case 0: // fall through
        default:
          break;
      }

      string? addr = null;
      string? port = null;
      string? username = null;
      string? password = null;

      if (type != null) {
        addr     = this.address.get_text()  == "" ? null : this.address.get_text();
        port     = this.port.get_text()     == "" ? null : this.port.get_text();
        username = this.username.get_text() == "" ? null : this.username.get_text();
        password = this.password.get_text() == "" ? null : this.password.get_text();
      }

      if (type != null && (addr == null || port == null)) {
        // Address and port are required to set up a proxy
        var dlg = new Gtk.MessageDialog(this, DESTROY_WITH_PARENT | MODAL, ERROR, OK, "Proxy address and proxy port are mandatory.");
        dlg.run();
        dlg.destroy();
      } else {
        // Pass the filled proxy data back to the caller
        this.callback_save(type, addr, port, username, password);

        // Then close the dialog
        this.destroy();
      }
    }
  }
}
