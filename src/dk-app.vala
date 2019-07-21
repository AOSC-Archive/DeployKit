namespace Dk {
  /**
   * Main application manager of DeployKit.
   */
  public class App : Gtk.Application {
    /**
     * Constructor of the application.
     *
     * This creates a ``Gtk.Application`` with project-defined attributes.
     */
    public App() {
      Object(application_id: "io.aosc.DeployKit", flags: GLib.ApplicationFlags.FLAGS_NONE);
    }

    /**
     * Signal handler for the ``activate`` signal of application.
     *
     * This is called when the program is started.
     */
    protected override void activate() {
      var guimain = new Dk.GuiMain();
      this.add_window(guimain);
      guimain.show_all();
    }
  }
}
