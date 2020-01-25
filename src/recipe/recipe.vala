namespace Dk {
/**
 * Models representing information in the recipe fetched from the repository.
 */
namespace Recipe {

/**
 * The Recipe class as is described in DeployKit recipe specification.
 */
public class Recipe : GLib.Object {
  /**
   * The API version used in the recipe.
   */
  private int version;

  /**
   * A Bulletin object, containing a bulletin message.
   */
  private Bulletin bulletin;

  /**
   * An array of Variant object, containing a series of tarball variants.
   */
  private Gee.ArrayList<Variant> variants;

  /**
   * An array of Mirror object, containing available mirrors for
   * downloading.
   */
  private Gee.ArrayList<Mirror> mirrors;

  /**
   * Constructor for Recipe.
   *
   * This constructor only initializes private variables to their default
   * states. Use the from_json method to fill the object with valid data.
   */
  public Recipe() {
    this.version = -1;
    this.bulletin = new Bulletin();
    this.variants = new Gee.ArrayList<Variant>();
    this.mirrors = new Gee.ArrayList<Mirror>();
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

      if (member == "version") {
        if (!reader.is_value())
          return false;

        this.set_version((int)reader.get_int_value());
      } else if (member == "bulletin") {
        if (!reader.is_object())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.bulletin", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        /* There should only be one Bulletin object. */
        var node_bulletin = query_result.get_array().get_element(0);

        var bulletin = new Bulletin();
        bulletin.from_json_node(node_bulletin);
        this.bulletin = bulletin;
      } else if (member == "variants") {
        if (!reader.is_array())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.variants", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        /* There should only be one Variants array. */
        var array_variants = query_result.get_array().get_element(0).get_array();

        array_variants.foreach_element((array, i, node) => {
          var variant = new Variant();
          variant.from_json_node(node);
          this.variants.add(variant);
        });
      } else if (member == "mirrors") {
        if (!reader.is_array())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.mirrors", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        /* There should only be one Mirrors array. */
        var array_mirrors = query_result.get_array().get_element(0).get_array();

        array_mirrors.foreach_element((array, i, node) => {
          var mirror = new Mirror();
          mirror.from_json_node(node);
          this.mirrors.add(mirror);
        });
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

    builder.set_member_name("version");
    builder.add_int_value(this.get_version());

    builder.set_member_name("variants");
    builder.begin_array();
    this.variants.foreach((v) => {
      builder.add_value(v.to_json_node());
      return true;
    });
    builder.end_array();

    builder.set_member_name("mirrors");
    builder.begin_array();
    this.mirrors.foreach((m) => {
      builder.add_value(m.to_json_node());
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

  public int get_version() {
    return this.version;
  }

  public void set_version(int version) {
    this.version = version;
  }

  public Bulletin get_bulletin() {
    return this.bulletin;
  }

  public void set_bulletin(Bulletin bulletin) {
    this.bulletin = bulletin;
  }

  public Gee.ArrayList<Variant> get_variants() {
    return this.variants;
  }

  public void set_variants(Gee.ArrayList<Variant> variants) {
    this.variants = variants;
  }

  public Gee.ArrayList<Mirror> get_mirrors() {
    return this.mirrors;
  }

  public void set_mirrors(Gee.ArrayList<Mirror> mirrors) {
    this.mirrors = mirrors;
  }
}

} /* namespace Recipe */
} /* namespace Dk */
