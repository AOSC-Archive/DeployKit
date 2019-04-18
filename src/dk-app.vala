namespace Dk {
  public class App : Gtk.Application {
    public App() {
      Object(application_id: "io.aosc.DeployKit", flags: GLib.ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate() {
      new Dk.GuiMain(this).show_all();
    }
  }
}
