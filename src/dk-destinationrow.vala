namespace Dk {
  /**
   * Template widget for use in the "Destination" section of recipe.
   */
  [GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-destinationrow.ui")]
  public class DestinationRow: Gtk.Box {
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
     * Constructor for ``Dk.DestinationRow``.
     *
     * @param icon_name        Name of icon to display.
     * @param destination_path Path to the destination.
     * @param description      Description on the type of destination.
     * @param capacity         Size of the destination, in byte.
     */
    public DestinationRow(string icon_name, string destination_path, string description, int64 capacity) {
      this.icon.set_from_icon_name(icon_name, Gtk.IconSize.DIALOG); // 48px
      this.destination_path.set_text(destination_path);
      this.description.set_text(description);

      if (capacity < 0)
        this.capacity.set_text("Unknown");
      else
        this.capacity.set_text(GLib.format_size(capacity, GLib.FormatSizeFlags.IEC_UNITS));
    }
  }
}
