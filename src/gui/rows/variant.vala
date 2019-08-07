namespace Dk {
namespace Gui {
namespace Rows {

/**
 * Template widget for use in the "Variants" section of recipe.
 */
[GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-variantrow.ui")]
public class Variant: Gtk.Box {
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
   * Download size of the variant.
   */
  [GtkChild]
  private Gtk.Label download_size;

  /**
   * Installation size of the variant.
   */
  [GtkChild]
  private Gtk.Label installation_size;

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
    this.icon.set_from_icon_name(icon_name, Gtk.IconSize.DIALOG); // 48px
    this.variant_name.set_text(variant_name);
    this.release_date.set_text(release_date);

    if (download_size < 0)
      this.download_size.set_text("Unknown");
    else
      this.download_size.set_text(GLib.format_size(download_size, GLib.FormatSizeFlags.IEC_UNITS));

    if (installation_size < 0)
      this.installation_size.set_text("Unknown");
    else
      this.installation_size.set_text(GLib.format_size(installation_size, GLib.FormatSizeFlags.IEC_UNITS));
  }
}

} /* namespace Rows */
} /* namespace Gui */
} /* namespace Dk */
