namespace Dk {
  [GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-destinationrow.ui")]
  public class DestinationRow: Gtk.Box {
    [GtkChild]
    private Gtk.Image icon;
    [GtkChild]
    private new Gtk.Label path; // Shadows Gtk.Widget.path
    [GtkChild]
    private Gtk.Label description;
    [GtkChild]
    private Gtk.Label capacity;

    public DestinationRow(string icon_name, string path, string description, uint64 capacity) {
      this.icon.set_from_icon_name(icon_name, Gtk.IconSize.DIALOG); // 48px
      this.path.set_text(path);
      this.description.set_text(description);
      this.capacity.set_text(GLib.format_size(capacity, GLib.FormatSizeFlags.IEC_UNITS));
    }
  }
}
