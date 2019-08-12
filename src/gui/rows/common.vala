namespace Dk {
namespace Gui {
namespace Rows {

/**
 * Set a human readable string on a Gtk.Label with an integral size.
 *
 * @param label The Gtk.Label to be set.
 * @param size  Size to be converted to a human readable string.
 */
private static void set_label_human_readable_size(Gtk.Label label, int64 size) {
  if (size < 0)
    label.set_text("Unknown");
  else
    label.set_text(GLib.format_size(size, GLib.FormatSizeFlags.IEC_UNITS));
}

} /* namespace Rows */
} /* namespace Gui */
} /* namespace Dk */
