namespace Dk {
/**
 * Models representing information in a DeployKit Internal Representation (DKIR) document.
 */
namespace Ir {

/**
 * The DKIR document object.
 */
public class Ir : Object {
  private int version;
  private PartitionInfo partition;
  private ExtractInfo extract;
  private Gee.ArrayList<string> extra_packages;
  private ConfigInfo configuration;
  private Gee.ArrayList<OverrideInfo> overrides;
  private BootLoaderInfo bootloader;

  public Ir() {
    this.version = -1;
    this.partition = new PartitionInfo();
    this.extract = new ExtractInfo();
    this.extra_packages = new Gee.ArrayList<string>();
    this.configuration = new ConfigInfo();
    this.overrides = new Gee.ArrayList<OverrideInfo>();
    this.bootloader = new BootLoaderInfo();
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
      case "version":
        if (!reader.is_value())
          return false;

        this.set_version((int)reader.get_int_value());
        break;
      case "partition":
        if (!reader.is_object())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.partition", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        var node_partition = query_result.get_array().get_element(0);

        var partition = new PartitionInfo();
        partition.from_json_node(node_partition);
        this.partition = partition;
        break;
      case "extract":
        if (!reader.is_object())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.extract", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        var node_extract = query_result.get_array().get_element(0);

        var extract = new ExtractInfo();
        extract.from_json_node(node_extract);
        this.extract = extract;
        break;
      case "extra_packages":
        if (!reader.is_array())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.extra_packages", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        var array_extra_packages = query_result.get_array().get_element(0).get_array();

        array_extra_packages.foreach_element((array, i, node) => this.extra_packages.add(node.dup_string()));
        break;
      case "configuration":
        if (!reader.is_object())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.configuration", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        var node_configuration = query_result.get_array().get_element(0);

        var configuration = new ConfigInfo();
        configuration.from_json_node(node_configuration);
        this.configuration = configuration;
        break;
      case "overrides":
        if (!reader.is_array())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.overrides", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        var array_overrides = query_result.get_array().get_element(0).get_array();

        array_overrides.foreach_element((array, i, node) => {
          var overriding = new OverrideInfo();
          overriding.from_json_node(node);
          this.overrides.add(overriding);
        });
        break;
      case "bootloader":
        if (!reader.is_object())
          return false;

        Json.Node? query_result = null;

        try {
          query_result = Json.Path.query("$.bootloader", node);
        } catch (Error e) {
          continue;
        }

        assert(query_result != null);
        assert(query_result.get_node_type() == Json.NodeType.ARRAY);

        var node_bootloader = query_result.get_array().get_element(0);

        var bootloader = new BootLoaderInfo();
        bootloader.from_json_node(node_bootloader);
        this.bootloader = bootloader;
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

    builder.set_member_name("version");
    builder.add_int_value(this.get_version());

    builder.set_member_name("partition");
    builder.add_value(this.partition.to_json_node());

    builder.set_member_name("extract");
    builder.add_value(this.extract.to_json_node());

    builder.set_member_name("extra_packages");
    builder.begin_array();
    this.extra_packages.foreach((p) => {
      builder.add_string_value(p);
      return true;
    });
    builder.end_array();

    builder.set_member_name("configuration");
    builder.add_value(this.configuration.to_json_node());

    builder.set_member_name("overrides");
    builder.begin_array();
    this.overrides.foreach((o) => {
      builder.add_value(o.to_json_node());
      return true;
    });
    builder.end_array();

    builder.set_member_name("bootloader");
    builder.add_value(this.bootloader.to_json_node());

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

  public PartitionInfo get_partition() {
    return this.partition;
  }

  public void set_partition(PartitionInfo partition) {
    this.partition = partition;
  }

  public ExtractInfo get_extract() {
    return this.extract;
  }

  public void set_extract(ExtractInfo extract) {
    this.extract = extract;
  }

  public Gee.ArrayList<string> get_extra_packages() {
    return this.extra_packages;
  }

  public void set_extra_packages(Gee.ArrayList<string> extra_packages) {
    this.extra_packages = extra_packages;
  }

  public ConfigInfo get_configuration() {
    return this.configuration;
  }

  public void set_configuration(ConfigInfo configuration) {
    this.configuration = configuration;
  }

  public Gee.ArrayList<OverrideInfo> get_overrides() {
    return this.overrides;
  }

  public void set_overrides(Gee.ArrayList<OverrideInfo> overrides) {
    this.overrides = overrides;
  }

  public BootLoaderInfo get_bootloader() {
    return this.bootloader;
  }

  public void set_bootloader(BootLoaderInfo bootloader) {
    this.bootloader = bootloader;
  }
}

}
}
