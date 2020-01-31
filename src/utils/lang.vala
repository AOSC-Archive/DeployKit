namespace Dk {
namespace Utils {

/**
 * Get the language string based on the current locale.
 *
 * This is mainly used in parsing the recipe, where localized strings may
 * occur. The returned string also complies with the specification of
 * recipe.
 *
 * @return A string representing the language DeployKit should choose to
 *         display localized strings.
 */
public static string get_lang() {
  string? locale = GLib.Intl.setlocale();
  if (locale == null || locale == "")
    return "en-us"; /* XXX: Default. */

  return locale.split(".")[0].down().replace("_", "-");
}

/**
 * The package name for Gettext to find internationalization (i18n) strings.
 *
 * Note that this string is only for Vala, and the macro for C sources is
 * defined in the build system in /po/meson.build.
 */
public static const string GETTEXT_PACKAGE = "aosc-dk";

} /* namespace Utils */
} /* namespace Dk */
