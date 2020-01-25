namespace Dk {
namespace Ir {

/**
 * The partition configuration object.
 */
public class PartitionInfo : Object {
  private bool format;
  private string filesystem;
  private string device;

  public PartitionInfo() {
    this.format = false;
    this.filesystem = "unknown";
    this.device = "unknown";
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
      case "format":
        if (!reader.is_value())
          return false;

        this.set_format(reader.get_boolean_value());
        break;
      case "filesystem":
        if (!reader.is_value())
          return false;

        this.set_filesystem(reader.get_string_value());
        break;
      case "device":
        if (!reader.is_value())
          return false;

        this.set_device(reader.get_string_value());
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
    builder.set_member_name("format");
    builder.add_boolean_value(this.format);
    builder.set_member_name("filesystem");
    builder.add_string_value(this.filesystem);
    builder.set_member_name("device");
    builder.add_string_value(this.device);
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

  public bool get_format() {
    return this.format;
  }

  public void set_format(bool format) {
    this.format = format;
  }

  public string get_filesystem() {
    return this.filesystem;
  }

  public void set_filesystem(string filesystem) {
    this.filesystem = filesystem;
  }

  public string get_device() {
    return this.device;
  }

  public void set_device(string device) {
    this.device = device;
  }
}

}
}
