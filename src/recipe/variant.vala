namespace Dk {
  namespace Recipe {
    /**
     * The Variant class as is described in DeployKit recipe specification.
     */
    public class Variant : GLib.Object {
      /**
       * Name of the variant (e.g. "GNOME").
       */
      private string name;

      /**
       * An array of tarballs under one variant.
       */
      private Gee.ArrayList<Tarball> tarballs;

      /**
       * A list of localized ``name`` strings.
       */
      private Gee.HashMap<string, string> name_l10n;

      /**
       * Constructor for Variant.
       *
       * This constructor only initializes private variables to their default
       * states. Use the from_json method to fill the object with valid data.
       */
      public Variant() {
        this.name = "Unknown";
        this.tarballs = new Gee.ArrayList<Tarball>();
        this.name_l10n = new Gee.HashMap<string, string>();
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

          if (member == "name") {
            this.set_name(reader.get_string_value());
          } else if (member == "tarballs")  {
            int elements = reader.count_elements();

            for (int i = 0; i < elements; i++) {
              reader.read_element(i);

              if (reader.is_object()) {
                /*
                  * json-glib does not have the ability to take a whole JSON
                  * object out, so we have to re-construct an object member-by-
                  * member...
                  */
                var tarball = new Tarball();

                if (reader.read_member("arch"))
                  tarball.set_arch(reader.get_string_value());
                reader.end_member();

                if (reader.read_member("date"))
                  tarball.set_date_from_string(reader.get_string_value());
                reader.end_member();

                if (reader.read_member("downloadSize"))
                  tarball.set_download_size(reader.get_int_value());
                reader.end_member();

                if (reader.read_member("instSize"))
                  tarball.set_installation_size(reader.get_int_value());
                reader.end_member();

                if (reader.read_member("path"))
                  tarball.set_path(reader.get_string_value());
                reader.end_member();

                this.tarballs.add(tarball);
              }

              reader.end_element();
            }
          } else if (member.has_prefix("name@")) {
            string lang = member.substring(5);
            this.set_name_l10n(lang, reader.get_string_value());
          } else {}

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

        builder.set_member_name("name");
        builder.add_string_value(this.name);

        this.name_l10n.map_iterator().foreach((k, v) => {
          builder.set_member_name("name@" + k);
          builder.add_string_value(v);

          return true;
        });

        builder.set_member_name("tarballs");
        builder.begin_array();
        this.tarballs.foreach((tarball) => {
          builder.add_value(tarball.to_json_node());
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

      public string get_name() {
        return this.name;
      }

      public void set_name(string name) {
        this.name = name;
      }

      public Gee.ArrayList<Tarball> get_tarballs() {
        return this.tarballs;
      }

      public void set_tarballs(Gee.ArrayList<Tarball> tarballs) {
        this.tarballs = tarballs;
      }

      public string get_name_l10n(string lang) {
        return this.name_l10n.get(lang);
      }

      public void set_name_l10n(string lang, string name) {
        this.name_l10n.set(lang, name);
      }
    }
  }
}
