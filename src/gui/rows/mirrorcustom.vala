namespace Dk {
namespace Gui {
namespace Rows {

/**
 * Template widget for use in the "Mirrors" section of recipe.
 */
[GtkTemplate (ui = "/io/aosc/DeployKit/ui/rows/mirrorcustom.ui")]
public class MirrorCustom: Gtk.Box {
  /**
   * URL to the mirror.
   */
  [GtkChild]
  private Gtk.Entry url;

  /**
   * Constructor for row ``MirrorCustom``.
   */
  public MirrorCustom() {}

  public string get_url() {
    return this.url.get_text();
  }

  [GtkCallback]
  private void delete_clicked_cb() {
    /* Typically ``this`` should be in a ``GtkListBoxRow``. If this is the case
     * then remove the row from the list (or a blank entry will still be in the
     * list.
     */
    var parent = this.get_parent();
    if (parent.get_type().is_a(Type.from_name("GtkListBoxRow")))
      parent.destroy();
    else
      this.destroy();
  }
}

} /* namespace Rows */
} /* namespace Gui */
} /* namespace Dk */
