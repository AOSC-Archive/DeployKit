namespace Dk {
namespace Ir {

/**
 * The boot loader configuration object.
 */
public class BootLoaderInfo : Object {
  private bool install;
  private string type;
  private string target;
  private string efi_directory;
  private string bootloader_id;

  public BootLoaderInfo() {
    this.install = false;
    this.type = "unknown";
    this.target = "unknown";
    this.efi_directory = "unknown";
    this.bootloader_id = "unknown";
  }

  /**
   * Fill the object with an existing Json.Node.
   *
   * This is useful when the caller has already parsed the JSON string with
   * json-glib, and can directly get a ``Json.Node`` from the parser.
   *
   * @param node A Json.Node from json-glib.
   * @return true if the deserialization process successfully finished, or
   *         false if the JSON node cannot represent this object.
   * @see from_json_string
   */
  public bool from_json_node(Json.Node node) {
    var reader = new Json.Reader(node);

    foreach (string member in reader.list_members()) {
      bool r = reader.read_member(member);
      if (!r) {
        reader.end_member();
        continue;
      }

      switch (member) {
      case "install":
        if (!reader.is_value())
          return false;

        this.set_install(reader.get_boolean_value());
        break;
      case "type":
        if (!reader.is_value())
          return false;

        this.set_loader_type(reader.get_string_value());
        break;
      case "target":
        if (!reader.is_value())
          return false;

        this.set_target(reader.get_string_value());
        break;
      case "efi_directory":
        if (!reader.is_value())
          return false;

        this.set_efi_directory(reader.get_string_value());
        break;
      case "bootloader_id":
        if (!reader.is_value())
          return false;

        this.set_bootloader_id(reader.get_string_value());
        break;
      default:
        break;
      }

      reader.end_member();
    }

    return true;
  }

  /**
   * Fill the object with a JSON string (deserialize).
   *
   * This method parses the given JSON string, and then calls
   * ``from_json_node`` to finish the process. Just use ``from_json_node``
   * if you have parsed the JSON string elsewhere, where a ``Json.Node`` can
   * be used.
   *
   * @param json The JSON string representing the object.
   * @return true if the deserialization process successfully finished, or
   *         false if the JSON string contains unrecognized parts.
   * @see from_json_node
   */
  public bool from_json_string(string json) {
    var parser = new Json.Parser();

    try {
      parser.load_from_data(json);
    } catch (Error e) {
      return false;
    }

    return this.from_json_node(parser.get_root());
  }

  /**
   * Outputs the object using ``Json.Node`` from ``json-glib``.
   *
   * @return The ``Json.Node`` representing the object.
   */
  public Json.Node to_json_node() {
    var builder = new Json.Builder();

    builder.begin_object();
    builder.set_member_name("install");
    builder.add_boolean_value(this.install);
    builder.set_member_name("type");
    builder.add_string_value(this.type);
    builder.set_member_name("target");
    builder.add_string_value(this.target);
    builder.set_member_name("efi_directory");
    builder.add_string_value(this.efi_directory);
    builder.set_member_name("bootloader_id");
    builder.add_string_value(this.bootloader_id);
    builder.end_object();

    return builder.get_root();
  }

  /**
   * Transform the object into a JSON string (serialize).
   *
   * @return The JSON representation of the object.
   */
  public string to_json_string() {
    var generator = new Json.Generator();
    generator.set_root(this.to_json_node());
    return generator.to_data(null);
  }

  /**
   * Transform the object into a string.
   *
   * This is currently equlvalent to ``to_json_string``.
   *
   * @return The string representation of the object.
   */
  public string to_string() {
    return this.to_json_string();
  }

  public bool get_install() {
    return this.install;
  }

  public void set_install(bool install) {
    this.install = install;
  }

  public string get_loader_type() {
    return this.type;
  }

  public void set_loader_type(string type) {
    this.type = type;
  }

  public string get_target() {
    return this.target;
  }

  public void set_target(string target) {
    this.target = target;
  }

  public string get_efi_directory() {
    return this.efi_directory;
  }

  public void set_efi_directory(string efi_directory) {
    this.efi_directory = efi_directory;
  }

  public string get_bootloader_id() {
    return this.bootloader_id;
  }

  public void set_bootloader_id(string bootloader_id) {
    this.bootloader_id = bootloader_id;
  }
}

}
}
