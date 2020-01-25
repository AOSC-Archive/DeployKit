namespace Dk {
namespace Ir {

/**
 * The object that represents a user in the target system.
 */
public class UserInfo : Object {
  private string id;
  private string password;
  private string name;
  private string homedir;
  private Gee.ArrayList<string> groups;

  public UserInfo() {
    this.id = "aosc";
    this.password = "";
    this.name = "";
    this.homedir = "/home/aosc";
    this.groups = new Gee.ArrayList<string>();
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
      case "id":
        if (!reader.is_value())
          return false;

        this.set_id(reader.get_string_value());
        break;
      case "password":
        if (!reader.is_value())
          return false;

        this.set_password(reader.get_string_value());
        break;
      case "name":
        if (!reader.is_value())
          return false;

        this.set_name(reader.get_string_value());
        break;
      case "homedir":
        if (!reader.is_value())
          return false;

        this.set_homedir(reader.get_string_value());
        break;
      case "groups":
        if (!reader.is_array())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.groups", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        var array_groups = query_result.get_array().get_element(0).get_array();

        array_groups.foreach_element((array, i, node) => this.groups.add(node.dup_string()));
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

    builder.set_member_name("id");
    builder.add_string_value(this.id);
    builder.set_member_name("password");
    builder.add_string_value(this.password);
    builder.set_member_name("name");
    builder.add_string_value(this.name);
    builder.set_member_name("homedir");
    builder.add_string_value(this.homedir);

    builder.set_member_name("groups");
    builder.begin_array();
    this.groups.foreach((g) => {
      builder.add_string_value(g);
      return true;
    });
    builder.end_array();

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

  public string get_id() {
    return this.id;
  }

  public void set_id(string id) {
    this.id = id;
  }

  public string get_password() {
    return this.password;
  }

  public void set_password(string password) {
    this.password = password;
  }

  public string get_name() {
    return this.name;
  }

  public void set_name(string name) {
    this.name = name;
  }

  public string get_homedir() {
    return this.homedir;
  }

  public void set_homedir(string homedir) {
    this.homedir = homedir;
  }

  public Gee.ArrayList<string> get_groups() {
    return this.groups;
  }

  public void set_groups(Gee.ArrayList<string> groups) {
    this.groups = groups;
  }
}

}
}
