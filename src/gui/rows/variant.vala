namespace Dk {
namespace Gui {
namespace Rows {

/**
 * Template widget for use in the "Variants" section of recipe.
 */
[GtkTemplate (ui = "/io/aosc/DeployKit/ui/rows/variant.ui")]
public class Variant: Gtk.Box {
  /**
   * Size of the icon (DIALOG, 48px for now).
   */
  private static Gtk.IconSize icon_size = Gtk.IconSize.DIALOG;

  /**
   * Icon identifying the variant.
   */
  [GtkChild]
  private Gtk.Image icon;

  /**
   * Name of the variant.
   */
  [GtkChild (name = "name")]
  private Gtk.Label variant_name;

  /**
   * Release date of the variant.
   */
  [GtkChild]
  private Gtk.Label release_date;

  /**
   * The original release date.
   */
  private GLib.DateTime release_date_orig;

  /**
   * Download size of the variant.
   */
  [GtkChild]
  private Gtk.Label download_size;

  /**
   * The original, non-formatted download size.
   */
  private int64 download_size_orig = 0;

  /**
   * Installation size of the variant.
   */
  [GtkChild]
  private Gtk.Label installation_size;

  /**
   * The original, non-formatted installation size.
   */
  private int64 installation_size_orig = 0;

  /**
   * Constructor for row ``Variant``.
   *
   * @param icon_name         Name of the icon to display.
   * @param variant_name      Name of the variant (e.g. "GNOME").
   * @param release_date      Date of variant release in string.
   * @param download_size     Size of the compressed file for user to download.
   * @param installation_size Size of the installed root (/).
   */
  public Variant(string icon_name, string variant_name, string release_date, int64 download_size, int64 installation_size) {
    this.set_icon_name(icon_name);
    this.set_name(variant_name);
    this.release_date.set_text(release_date); // TODO
    this.set_download_size(download_size);
    this.set_installation_size(installation_size);
  }

  public string get_icon_name() {
    string icon_name;
    this.icon.get_icon_name(out icon_name, null);
    return icon_name;
  }

  public string get_name() {
    return this.variant_name.get_text().dup();
  }

  public GLib.DateTime get_release_date() {
    return this.release_date_orig;
  }

  public string get_release_date_string() {
    return this.release_date.get_text().dup();
  }

  public int64 get_download_size() {
    return this.download_size_orig;
  }

  public string get_download_size_string() {
    return this.download_size.get_text().dup();
  }

  public int64 get_installation_size() {
    return this.installation_size_orig;
  }

  public string get_installation_size_string() {
    return this.installation_size.get_text().dup();
  }

  public void set_icon_name(string icon_name) {
    this.icon.set_from_icon_name(icon_name, icon_size);
  }

  public void set_name(string name) {
    this.variant_name.set_text(name);
  }

  public void set_release_date(GLib.DateTime datetime) {
    this.release_date_orig = datetime;
    // TODO
  }

  public void set_download_size(int64 download_size) {
    this.download_size_orig = download_size;
    Rows.set_label_human_readable_size(this.download_size, download_size);
  }

  public void set_installation_size(int64 installation_size) {
    this.installation_size_orig = installation_size;
    Rows.set_label_human_readable_size(this.installation_size, installation_size);
  }
}

} /* namespace Rows */
} /* namespace Gui */
} /* namespace Dk */
