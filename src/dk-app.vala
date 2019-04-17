namespace Dk {
  public class App : Gtk.Application {
    public App() {
      new Gtk.Application("io.aosc.DeployKit", GLib.ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate() {
      new Dk.GuiMain(this).show_all();
    }
  }
}
