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
      Object(application_id: "io.aosc.DeployKit", flags: GLib.ApplicationFlags.HANDLES_OPEN);
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

    /**
     * Signal handler for the ``open`` signal of application.
     *
     * This is called when the program is started with a list of file appended
     * in the command line. The appended file is expected to be a
     * ``recipe.json`` file as specified in the corresponding specification in
     * documentation.
     *
     * @param files A list of files.
     * @param hint  A hint (?).
     */
    protected override void open(GLib.File[] files, string hint) {
      var guimain = new Dk.GuiMain();

      if (files.length > 1)
        GLib.message("more than one local recipe are given, only the first one will be processed.");

      guimain.set_local_recipe(files[0]);

      this.add_window(guimain);
      guimain.show_all();
    }
  }
}
