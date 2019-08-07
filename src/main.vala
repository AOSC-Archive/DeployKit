namespace Dk {

/**
 * Main entry of DeployKit.
 *
 * This function does virtually nothing but spawning a Gtk.Application.
 *
 * @param args Command-line arguments.
 * @return What should be returned to the operating system.
 */
public static int main(string[] args) {
  return new Dk.App().run(args);
}

} /* namespace Dk */
