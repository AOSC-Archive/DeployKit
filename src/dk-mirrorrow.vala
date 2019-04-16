namespace Dk {
  [GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-mirrorrow.ui")]
  public class MirrorRow: Gtk.Box {
    [GtkChild]
    private Gtk.Image icon;
    [GtkChild]
    private new Gtk.Label name; // Shadows Gtk.Widget.name
    [GtkChild]
    private Gtk.Label location;

    public MirrorRow(string icon_name, string name, string location) {
      this.icon.set_from_icon_name(icon_name, Gtk.IconSize.DIALOG); // 48px
      this.name.set_text(name);
      this.location.set_text(location);
    }
  }
}
