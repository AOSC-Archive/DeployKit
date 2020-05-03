namespace Dk {
namespace Mirrors {

public class AoscApiMirror : Object {
  private string name;
  private string region;
  private string url;
  private int64 updated;
  private double checked;

  public AoscApiMirror() {
    this.name = _("Unknown");
    this.region = _("Unknown");
    this.url = _("Unknown");
    this.updated = -1;
    this.checked = -1.0;
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
      case "name":
        if (!reader.is_value())
          return false;

        this.set_name(reader.get_string_value());
        break;
      case "region":
        if (!reader.is_value())
          return false;

        this.set_region(reader.get_string_value());
        break;
      case "url":
        if (!reader.is_value())
          return false;

        this.set_url(reader.get_string_value());
        break;
      case "updated":
        if (!reader.is_value())
          return false;

        this.set_updated(reader.get_int_value());
        break;
      case "checked":
        if (!reader.is_value())
          return false;

        this.set_checked(reader.get_double_value());
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
    builder.set_member_name("name");
    builder.add_string_value(this.get_name());
    builder.set_member_name("region");
    builder.add_string_value(this.get_region());
    builder.set_member_name("url");
    builder.add_string_value(this.get_url());
    builder.set_member_name("updated");
    builder.add_int_value(this.get_updated());
    builder.set_member_name("checked");
    builder.add_double_value(this.get_checked());
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

  public string get_name() {
    return this.name;
  }

  public void set_name(string name) {
    this.name = name;
  }

  public string get_region() {
    return this.region;
  }

  public void set_region(string region) {
    this.region = region;
  }

  public string get_url() {
    return this.url;
  }

  public void set_url(string url) {
    this.url = url;
  }

  public int64 get_updated() {
    return this.updated;
  }

  public void set_updated(int64 updated) {
    this.updated = updated;
  }

  public double get_checked() {
    return this.checked;
  }

  public void set_checked(double checked) {
    this.checked = checked;
  }
}

}
}
