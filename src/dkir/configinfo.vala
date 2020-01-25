namespace Dk {
namespace Ir {

/**
 * The system configuration object.
 */
public class ConfigInfo : Object {
  private string root_password;
  private string hostname;
  private string timezone;
  private Gee.ArrayList<UserInfo> users;

  public ConfigInfo() {
    this.root_password = "";
    this.hostname = "aosc";
    this.timezone = "UTC";
    this.users = new Gee.ArrayList<UserInfo>();
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
      case "root_password":
        if (!reader.is_value())
          return false;

        this.set_root_password(reader.get_string_value());
        break;
      case "hostname":
        if (!reader.is_value())
          return false;

        this.set_hostname(reader.get_string_value());
        break;
      case "timezone":
        if (!reader.is_value())
          return false;

        this.set_timezone(reader.get_string_value());
        break;
      case "users":
        if (!reader.is_array())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.users", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        var array_users = query_result.get_array().get_element(0).get_array();

        array_users.foreach_element((array, i, node) => {
          var user = new UserInfo();
          user.from_json_node(node);
          this.users.add(user);
        });
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

    builder.set_member_name("root_password");
    builder.add_string_value(this.root_password);
    builder.set_member_name("hostname");
    builder.add_string_value(this.hostname);
    builder.set_member_name("timezone");
    builder.add_string_value(this.timezone);

    builder.set_member_name("users");
    builder.begin_array();
    this.users.foreach((u) => {
      builder.add_value(u.to_json_node());
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

  public string get_root_password() {
    return this.root_password;
  }

  public void set_root_password(string root_password) {
    this.root_password = root_password;
  }

  public string get_hostname() {
    return this.hostname;
  }

  public void set_hostname(string hostname) {
    this.hostname = hostname;
  }

  public string get_timezone() {
    return this.timezone;
  }

  public void set_timezone(string timezone) {
    this.timezone = timezone;
  }

  public Gee.ArrayList<UserInfo> get_users() {
    return this.users;
  }

  public void set_users(Gee.ArrayList<UserInfo> users) {
    this.users = users;
  }
}

}
}
