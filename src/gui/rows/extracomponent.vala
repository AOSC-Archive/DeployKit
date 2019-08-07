namespace Dk {
namespace Gui {
namespace Rows {

/**
 * Template widget for use in the "Extra Components" section of recipe.
 */
[GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-extracomponentrow.ui")]
public class ExtraComponent : Gtk.Box {
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
   * Installation size of the component, in human readable format.
   */
  [GtkChild]
  private Gtk.Label installation_size;

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
    this.icon.set_from_icon_name(icon_name, Gtk.IconSize.DIALOG); // 48px
    this.component_name.set_text(component_name);
    this.description.set_text(description);

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