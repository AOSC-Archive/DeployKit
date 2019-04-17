namespace Dk {
  [GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-destinationrow.ui")]
  public class DestinationRow: Gtk.Box {
    [GtkChild]
    private Gtk.Image icon;
    [GtkChild (name = "path")]
    private Gtk.Label destination_path;
    [GtkChild]
    private Gtk.Label description;
    [GtkChild]
    private Gtk.Label capacity;

    public DestinationRow(string icon_name, string destination_path, string description, uint64 capacity) {
      this.icon.set_from_icon_name(icon_name, Gtk.IconSize.DIALOG); // 48px
      this.destination_path.set_text(destination_path);
      this.description.set_text(description);
      this.capacity.set_text(GLib.format_size(capacity, GLib.FormatSizeFlags.IEC_UNITS));
    }
  }
}
