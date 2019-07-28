namespace Dk {
  namespace Recipe {
    /**
     * The Tarball class as is described in DeployKit recipe specification.
     */
    public class Tarball : GLib.Object {
      /**
       * A string representing the processor architecture that the tarball is
       * built for.
       */
      private string arch;

      /**
       * Date of the build time of tarball.
       *
       * The use of ``GLib.DateTime`` allows a flexible date (and probably time)
       * output through the corresponding getter methods.
       */
      private GLib.DateTime date;

      /**
       * Size of the compressed tarball (download size).
       */
      private int64 download_size;

      /**
       * Size of the expanded tarball (installation size).
       */
      private int64 installation_size;

      /**
       * String representing the path to the tarball.
       *
       * This is a URL string without the mirror address (e.g. "/xxx.tar.xz").
       */
      private string path;

      /**
       * Constructor for Tarball.
       *
       * This constructor only initializes private variables to their default
       * states. Use ``from_json`` to fill the object with valid data.
       */
      public Tarball() {
        this.arch = "Generic";
        this.date = new GLib.DateTime.from_unix_utc(0);
        this.download_size = -1;
        this.installation_size = -1;
        this.path = "Unknown";
      }

      /**
       * Fill the object with an existing Json.Node.
       *
       * This is useful when the caller has already parsed the JSON string with
       * json-glib, and can directly get a ``Json.Node`` from the parser.
       *
       * @param node A Json.Node from json-glib.
       * @see from_json_string
       */
      public void from_json_node(Json.Node node) {
        var reader = new Json.Reader(node);

        foreach (string member in reader.list_members()) {
          bool r = reader.read_member(member);
          if (!r) {
            reader.end_member();
            continue;
          }

          switch (member) {
          case "arch":
            this.set_arch(reader.get_string_value());
            break;
          case "date":
            this.set_date_from_string(reader.get_string_value());
            break;
          case "downloadSize":
            this.set_download_size(reader.get_int_value());
            break;
          case "instSize":
            this.set_installation_size(reader.get_int_value());
            break;
          case "path":
            this.set_path(reader.get_string_value());
            break;
          default:
            break;
          }

          reader.end_member();
        }
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

        this.from_json_node(parser.get_root());

        return true;
      }

      /**
       * Outputs the object using ``Json.Node`` from ``json-glib``.
       *
       * @return The ``Json.Node`` representing the object.
       */
      public Json.Node to_json_node() {
        var builder = new Json.Builder();

        builder.begin_object();
        builder.set_member_name("arch");
        builder.add_string_value(this.get_arch());
        builder.set_member_name("date");
        builder.add_string_value(this.get_date().format("%Y%m%d"));
        builder.set_member_name("downloadSize");
        builder.add_int_value(this.get_download_size());
        builder.set_member_name("instSize");
        builder.add_int_value(this.get_installation_size());
        builder.set_member_name("path");
        builder.add_string_value(this.get_path());
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

      public string get_arch() {
        return this.arch;
      }

      public void set_arch(string arch) {
        this.arch = arch;
      }

      public GLib.DateTime get_date() {
        return this.date;
      }

      public void set_date(GLib.DateTime date) {
        this.date = date;
      }

      public bool set_date_from_string(string date_str) {
        /*
         * NB: A "valid ISO 8601 formatted string" must contain at least the
         * date part and the time part, with a delimiter in between. However, in
         * the recipe specification, "date" only contains the date part, and
         * thus the string cannot be parsed by GLib. Here we do a little trick
         * to make GLib happy.
         */
        string datetime_str = ("T" in date_str || " " in date_str) ? date_str : date_str + "T000000";

        /*
         * "This call can fail (returning null) if text is not a valid ISO 8601
         * formatted string."
         * -- https://valadoc.org/glib-2.0/GLib.DateTime.DateTime.from_iso8601.html
         *
         * How?
         */
        var date = new DateTime.from_iso8601(datetime_str, new TimeZone.utc());
        if (date != null) {
          this.date = date;
          return true;
        }

        return false;
      }

      public int64 get_download_size() {
        return this.download_size;
      }

      public void set_download_size(int64 download_size) {
        this.download_size = download_size;
      }

      public int64 get_installation_size() {
        return this.installation_size;
      }

      public void set_installation_size(int64 installation_size) {
        /* -1 represents unknown size */
        if (installation_size < -1)
          this.installation_size = -1;
        else
          this.installation_size = installation_size;
      }

      public string get_path() {
        return this.path;
      }

      public void set_path(string path) {
        this.path = path;
      }
    }
  }
}
