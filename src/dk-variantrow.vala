namespace Dk {
  [GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-variantrow.ui")]
  public class VariantRow: Gtk.Box {
    [GtkChild]
    private Gtk.Image icon;
    [GtkChild]
    private new Gtk.Label name; // Shadows Gtk.Widget.name
    [GtkChild]
    private Gtk.Label release_date;
    [GtkChild]
    private Gtk.Label download_size;
    [GtkChild]
    private Gtk.Label installation_size;

    public VariantRow(string icon_name, string name, string release_date, uint64 download_size, uint64 installation_size) {
      this.icon.set_from_icon_name(icon_name, Gtk.IconSize.DIALOG); // 48px
      this.name.set_text(name);
      this.release_date.set_text(release_date);
      this.download_size.set_text(GLib.format_size(download_size, GLib.FormatSizeFlags.IEC_UNITS));
      this.installation_size.set_text(GLib.format_size(installation_size, GLib.FormatSizeFlags.IEC_UNITS));
    }
  }
}
