namespace Dk {
  int main(string[] args) {
    Gtk.init(ref args);

    var builder_guimain = new Gtk.Builder.from_resource("/io/aosc/DeployKit/ui/dk-guimain.ui");
    builder_guimain.connect_signals(builder_guimain);

    var win_main = builder_guimain.get_object("dk_gui_main") as Gtk.Widget?;
    if (win_main == null)
      GLib.error("main window widget is missing from the (corrupted?) resource");

    win_main.show_all();
    Gtk.main();

    return 0;
  }
}
