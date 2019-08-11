namespace Dk {
namespace Recipe {

/**
 * The Bulletin class as is described in DeployKit recipe specification.
 *
 * A bulletin object represents what the developer (vendor) team want to
 * tell users, which can be some general information, or warnings about
 * accidents, or errors found in the products.
 */
public class Bulletin : GLib.Object {
  /**
   * Type of the bulletin message.
   *
   * This should normally be one of the following:
   *
   * - "unknown": The object is uninitialized.
   * - "none": No message is carried.
   * - "info": Informative message.
   * - "warning": Warning message.
   * - "fatal": Fatal message.
   *
   * For forward and backward compatibility consideration, this field is
   * a string, rather than an enumeration (``enum``). The user of the object
   * should check the returned string.
   */
  private string type;

  /**
   * Title of the bulletin message (optional).
   */
  private string? title;

  /**
   * Body of the bulletin message (optional).
   */
  private string? body;

  /**
   * A list of localized ``title`` strings.
   */
  private Gee.HashMap<string, string> title_l10n;

  /**
   * A list of localized ``body`` strings.
   */
  private Gee.HashMap<string, string> body_l10n;

  /**
   * Constructor for Bulletin.
   *
   * This constructor only initializes private variables to their default
   * states. Use the from_json method to fill the object with valid data.
   */
  public Bulletin() {
    this.type = "unknown";
    this.title = null;
    this.body = null;
    this.title_l10n = new Gee.HashMap<string, string>();
    this.body_l10n = new Gee.HashMap<string, string>();
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

      if (member == "type") {
        if (!reader.is_value())
          return false;

        this.set_bulletin_type(reader.get_string_value());
      } else if (member == "title") {
        if (!reader.is_value())
          return false;

        this.set_title(reader.get_string_value());
      } else if (member == "body") {
        if (!reader.is_value())
          return false;

        this.set_body(reader.get_string_value());
      } else if (member.has_prefix("title@")) {
        if (!reader.is_value())
          return false;

        string lang = member.substring(6);
        this.set_title_l10n(lang, reader.get_string_value());
      } else if (member.has_prefix("body@")) {
        if (!reader.is_value())
          return false;

        string lang = member.substring(5);
        this.set_body_l10n(lang, reader.get_string_value());
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

    builder.set_member_name("type");
    builder.add_string_value(this.get_bulletin_type());

    builder.set_member_name("title");
    builder.add_string_value(this.get_title());

    this.title_l10n.map_iterator().foreach((k, v) => {
      builder.set_member_name("title@" + k);
      builder.add_string_value(v);

      return true;
    });

    builder.set_member_name("body");
    builder.add_string_value(this.get_body());

    this.body_l10n.map_iterator().foreach((k, v) => {
      builder.set_member_name("body@" + k);
      builder.add_string_value(v);

      return true;
    });

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

  public string get_bulletin_type() {
    return this.type;
  }

  public void set_bulletin_type(string type) {
    this.type = type;
  }

  public string get_title() {
    return this.title;
  }

  public void set_title(string title) {
    this.title = title;
  }

  public string get_body() {
    return this.body;
  }

  public void set_body(string body) {
    this.body = body;
  }

  public string get_title_l10n(string lang) {
    return this.title_l10n.get(lang);
  }

  public void set_title_l10n(string lang, string title) {
    this.title_l10n.set(lang, title);
  }

  public string get_body_l10n(string lang) {
    return this.body_l10n.get(lang);
  }

  public void set_body_l10n(string lang, string title) {
    this.body_l10n.set(lang, title);
  }
}

} /* namespace Recipe */
} /* namespace Dk */
