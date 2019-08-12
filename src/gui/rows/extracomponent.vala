namespace Dk {
namespace Gui {
namespace Rows {

/**
 * Template widget for use in the "Extra Components" section of recipe.
 */
[GtkTemplate (ui = "/io/aosc/DeployKit/ui/rows/extracomponent.ui")]
public class ExtraComponent : Gtk.Box {
  /**
   * Size of the icon (DIALOG, 48px for now).
   */
  private static Gtk.IconSize icon_size = Gtk.IconSize.DIALOG;

  /**
   * Icon identifying the component pack.
   */
  [GtkChild]
  private Gtk.Image icon;

  /**
   * Name of the component.
   */
  [GtkChild (name = "name")]
  private Gtk.Label component_name;

  /**
   * Description on the component.
   */
  [GtkChild]
  private Gtk.Label description;

  /**
   * Download size of the component, in human readable format.
   */
  [GtkChild]
  private Gtk.Label download_size;

  /**
   * The original, non-formatted download size.
   */
  private int64 download_size_orig = 0;

  /**
   * Installation size of the component, in human readable format.
   */
  [GtkChild]
  private Gtk.Label installation_size;

  /**
   * The original, non-formatted installation size.
   */
  private int64 installation_size_orig = 0;

  /**
   * Constructor for row ``ExtraComponent``.
   *
   * @param icon_name         Name of icon identifying the component.
   * @param component_name    Name of the component.
   * @param description       Description for the component.
   * @param download_size     Download size of the component, in byte.
   * @param installation_size Installation size of the component, in byte.
   */
  public ExtraComponent(string icon_name, string component_name, string description, int64 download_size, int64 installation_size) {
    this.set_icon_name(icon_name);
    this.set_name(component_name);
    this.set_description(description);
    this.set_download_size(download_size);
    this.set_installation_size(installation_size);
  }

  public string get_icon_name() {
    string icon_name;
    this.icon.get_icon_name(out icon_name, null);
    return icon_name;
  }

  public string get_name() {
    return this.component_name.get_text().dup();
  }

  public string get_description() {
    return this.description.get_text().dup();
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
    this.component_name.set_text(name);
  }

  public void set_description(string description) {
    this.description.set_text(description);
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
