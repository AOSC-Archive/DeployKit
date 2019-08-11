namespace Dk {
namespace Recipe {

/**
 * The Mirror class as is described in DeployKit recipe specification.
 */
public class Mirror : GLib.Object {
  /**
   * Name of the mirror (e.g. "LUG@USTC").
   */
  private string name;

  /**
   * Location of the mirror, for the user's reference.
   */
  private string loc;

  /**
   * URL (address) of the mirror.
   */
  private string url;

  /**
   * A list of localized ``name`` strings.
   */
  private Gee.HashMap<string, string> name_l10n;

  /**
   * A list of localized ``loc`` strings.
   */
  private Gee.HashMap<string, string> loc_l10n;

  /**
   * Constructor for Mirror.
   *
   * This constructor only initializes private variables to their default
   * states. Use the from_json method to fill the object with valid data.
   */
  public Mirror() {
    this.name = "Unknown";
    this.loc = "Unknown";
    this.url = "Unknown";
    this.name_l10n = new Gee.HashMap<string, string>();
    this.loc_l10n = new Gee.HashMap<string, string>();
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

      if (member == "name") {
        if (!reader.is_value())
          return false;

        this.set_name(reader.get_string_value());
      } else if (member == "loc") {
        if (!reader.is_value())
          return false;

        this.set_location(reader.get_string_value());
      } else if (member == "url") {
        if (!reader.is_value())
          return false;

        this.set_url(reader.get_string_value());
      } else if (member.has_prefix("name@")) {
        if (!reader.is_value())
          return false;

        string lang = member.substring(5);
        this.set_name_l10n(lang, reader.get_string_value());
      } else if (member.has_prefix("loc@")) {
        if (!reader.is_value())
          return false;

        string lang = member.substring(4);
        this.set_location_l10n(lang, reader.get_string_value());
      } else {}

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

    this.name_l10n.map_iterator().foreach((k, v) => {
      builder.set_member_name("name@" + k);
      builder.add_string_value(v);

      return true;
    });

    builder.set_member_name("loc");
    builder.add_string_value(this.get_location());

    this.loc_l10n.map_iterator().foreach((k, v) => {
      builder.set_member_name("loc@" + k);
      builder.add_string_value(v);

      return true;
    });

    builder.set_member_name("url");
    builder.add_string_value(this.get_url());

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
   */
  public string to_string() {
    return this.to_json_string();
  }

  /**
   * Transform the object into a string.
   *
   * This is currently equlvalent to ``to_json_string``.
   *
   * @return The string representation of the object.
   */
  public string get_name() {
    return this.name;
  }

  public void set_name(string name) {
    this.name = name;
  }

  public string get_location() {
    return this.loc;
  }

  public void set_location(string loc) {
    this.loc = loc;
  }

  public string get_url() {
    return this.url;
  }

  public void set_url(string url) {
    this.url = url;
  }

  public string get_name_l10n(string lang) {
    return this.name_l10n.get(lang);
  }

  public void set_name_l10n(string lang, string name) {
    this.name_l10n.set(lang, name);
  }

  public string get_location_l10n(string lang) {
    return this.loc_l10n.get(lang);
  }

  public void set_location_l10n(string lang, string name) {
    this.loc_l10n.set(lang, name);
  }
}

} /* namespace Recipe */
} /* namespace Dk */
