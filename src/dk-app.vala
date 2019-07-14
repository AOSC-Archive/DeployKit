namespace Dk {
  public class App : Gtk.Application {
    public App() {
      Object(application_id: "io.aosc.DeployKit", flags: GLib.ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate() {
      var guimain = new Dk.GuiMain(this);
      this.add_window(guimain);
      guimain.show_all();
    }
  }
}
