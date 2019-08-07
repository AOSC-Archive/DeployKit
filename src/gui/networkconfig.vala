namespace Dk {
namespace Gui {

/**
 * Enumeration representing the type of a network proxy.
 *
 * This is matched with the item IDs in the Gtk.ComboBoxText in GUI.
 */
public enum ProxyType {
  /** Proxy disabled. */
  DISABLE = 0,

  /** Use HTTP proxy. */
  HTTP    = 1,

  /** Use HTTPS proxy. */
  HTTPS   = 2,

  /** Use SOCKS5 proxy. */
  SOCKS5  = 3,
}

/**
  * Callback for the dialog to save what the user filled in.
  *
  * @param proxy_type     Type of the proxy in Dk.ProxyType.
  * @param proxy_address  Address of the proxy.
  * @param proxy_port     Port to connect to.
  * @param proxy_username Username for the proxy.
  * @param proxy_password Password for the proxy.
  */
public delegate void NetworkConfigSaveCb(ProxyType? proxy_type, string? proxy_address, string? proxy_port, string? proxy_username, string? proxy_password);

/**
  * A network configuration dialog.
  *
  * The dialog allows the user to set up a proxy for download, or to enable
  * offline mode (use DeployKit without an Internet connection) manually for
  * large scale deployment or advanced installation.
  */
[GtkTemplate (ui = "/io/aosc/DeployKit/ui/networkconfig.ui")]
public class NetworkConfig : Gtk.Window {
  /**
    * The "Done" button for the user to save the form.
    */
  [GtkChild (name = "btn_done")]
  private Gtk.Button done;

  /**
    * The drop down for user to select the type of proxy.
    */
  [GtkChild (name = "combobox_type")]
  private Gtk.ComboBoxText proxy_type;

  /**
    * Input entry for proxy address.
    */
  [GtkChild (name = "entry_addr")]
  private Gtk.Entry address;

  /**
    * Input entry for proxy port.
    */
  [GtkChild (name = "entry_port")]
  private Gtk.Entry port;

  /**
    * Input entry for username of the require-to-login proxy.
    */
  [GtkChild (name = "entry_username")]
  private Gtk.Entry username;

  /**
    * Input entry for password of the require-to-login proxy.
    */
  [GtkChild (name = "entry_password")]
  private Gtk.Entry password;

  /**
    * Dk.NetworkConfigSaveCb for saving the form.
    */
  private NetworkConfigSaveCb callback_save;

  /**
    * Constructor for Dk.NetworkConfig.
    *
    * The parameters for constructor is for the caller to fill what the user
    * just set back to the dialog in order not to confuse the user.
    *
    * @param type     Type of the proxy.
    * @param addr     Address of the proxy.
    * @param port     Port of the proxy.
    * @param username Username for the proxy.
    * @param password Password for the proxy.
    */
  public NetworkConfig(ProxyType? type, string? addr, string? port, string? username, string? password, NetworkConfigSaveCb cb) {
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

  /**
    * Callback on ``changed`` event of combo-box ``proxy_type``.
    *
    * The form should be cleared when the proxy type is changed.
    */
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

  /**
    * Callback on ``clicked`` event of button ``done``.
    *
    * The function retrieves data from the form, converts them into data types
    * defined in delegate NetworkConfigSaveCb, and calls it to "save" the
    * network settings.
    */
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

} /* namespace Gui */
} /* namespace Dk */
