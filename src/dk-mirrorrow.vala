namespace Dk {
  [GtkTemplate (ui = "/io/aosc/DeployKit/ui/dk-mirrorrow.ui")]
  public class MirrorRow: Gtk.Box {
    [GtkChild]
    private Gtk.Image icon;
    [GtkChild (name = "name")]
    private Gtk.Label mirror_name;
    [GtkChild]
    private Gtk.Label location;

    public MirrorRow(string icon_name, string mirror_name, string location) {
      this.icon.set_from_icon_name(icon_name, Gtk.IconSize.DIALOG); // 48px
      this.mirror_name.set_text(mirror_name);
      this.location.set_text(location);
    }
  }
}
