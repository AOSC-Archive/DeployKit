namespace Dk {
namespace Gui {
namespace Rows {

/**
 * Template widget for use in the "Destination" section of recipe.
 */
[GtkTemplate (ui = "/io/aosc/DeployKit/ui/rows/destination.ui")]
public class Destination: Gtk.Box {
  /**
   * Size of the icon (DIALOG, 48px for now).
   */
  private static Gtk.IconSize icon_size = Gtk.IconSize.DIALOG;

  /**
   * Icon identifying the type of location (e.g. SSD, HDD, NVMe)
   */
  [GtkChild]
  private Gtk.Image icon;

  /**
   * Device path to the destination for identification.
   */
  [GtkChild (name = "path")]
  private Gtk.Label destination_path;

  /**
   * Description on the type of location.
   */
  [GtkChild]
  private Gtk.Label description;

  /**
   * Size of the destination, in human readable format.
   */
  [GtkChild]
  private Gtk.Label capacity;

  /**
   * The original, non-formatted capacity number.
   */
  private int64 capacity_orig = 0;

  /**
   * Constructor for row ``Destination``.
   *
   * @param icon_name        Name of icon to display.
   * @param destination_path Path to the destination.
   * @param description      Description on the type of destination.
   * @param capacity         Size of the destination, in byte.
   */
  public Destination(string icon_name, string destination_path, string description, int64 capacity) {
    this.set_icon_name(icon_name);
    this.set_path(destination_path);
    this.set_description(description);
    this.set_capacity(capacity);
  }

  public string get_icon_name() {
    string icon_name;
    this.icon.get_icon_name(out icon_name, null);
    return icon_name;
  }

  public string get_destination_path() {
    return this.destination_path.get_text().dup();
  }

  public string get_description() {
    return this.description.get_text().dup();
  }

  public int64 get_capacity() {
    return this.capacity_orig;
  }

  public string get_capacity_string() {
    return this.capacity.get_text().dup();
  }

  public void set_icon_name(string icon_name) {
    this.icon.set_from_icon_name(icon_name, icon_size);
  }

  public void set_path(string path) {
    this.destination_path.set_text(path);
  }

  public void set_description(string description) {
    this.description.set_text(description);
  }

  public void set_capacity(int64 capacity) {
    this.capacity_orig = capacity;
    Rows.set_label_human_readable_size(this.capacity, capacity);
  }
}

} /* namespace Rows */
} /* namespace Gui */
} /* namespace Dk */
