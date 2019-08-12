namespace Dk {
namespace Gui {
namespace Rows {

/**
 * Template widget for use in the "Mirrors" section of recipe.
 */
[GtkTemplate (ui = "/io/aosc/DeployKit/ui/rows/mirror.ui")]
public class Mirror: Gtk.Box {
  /**
   * Size of the icon (DIALOG, 48px for now).
   */
  private static Gtk.IconSize icon_size = Gtk.IconSize.DIALOG;

  /**
   * Icon identifying the mirror.
   */
  [GtkChild]
  private Gtk.Image icon;

  /**
   * Name of the mirror.
   */
  [GtkChild (name = "name")]
  private Gtk.Label mirror_name;

  /**
   * Location of the mirror.
   */
  [GtkChild]
  private Gtk.Label location;

  /**
   * Constructor for row ``Mirror``.
   *
   * @param icon_name   Name of the icon to display.
   * @param mirror_name Name of the mirror (e.g. "LUG@USTC").
   * @param location    Location of the mirror (e.g. "Hefei, Anhui, China").
   */
  public Mirror(string icon_name, string mirror_name, string location) {
    this.set_icon_name(icon_name);
    this.set_name(mirror_name);
    this.set_location(location);
  }

  public string get_icon_name() {
    string icon_name;
    this.icon.get_icon_name(out icon_name, null);
    return icon_name;
  }

  public string get_name() {
    return this.mirror_name.get_text().dup();
  }

  public string get_location() {
    return this.location.get_text().dup();
  }

  public void set_icon_name(string icon_name) {
    this.icon.set_from_icon_name(icon_name, icon_size);
  }

  public void set_name(string name) {
    this.mirror_name.set_text(name);
  }

  public void set_location(string location) {
    this.location.set_text(location);
  }
}

} /* namespace Rows */
} /* namespace Gui */
} /* namespace Dk */
