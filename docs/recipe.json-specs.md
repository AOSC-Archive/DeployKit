# Specification for Recipe (`recipe.json`) for AOSC OS DeployKit

This document specifies the structure and fields of `recipe.json`, which is a configuration file stored on AOSC repository server ([repo.aosc.io][repo]) for the installer to fetch and display.

[repo]: https://repo.aosc.io

Document version: 0.2 (Unstable)

## File Location

`recipe.json` is designed to be fetched by a DeployKit client, so its position should be fixed for easier implementation. The file should be located in:

```
<root_url>/aosc-os/recipe.json
```

... where

- `<root_url>` is the unified resource locator (URL) to AOSC OS repository. Normally, this should be `repo.aosc.io`. Example:

```
https://repo.aosc.io/aosc-os/recipe.json
```

The client is advised not to hard-code the root URL.

## Definition

A full example of `recipe.json`:

```json
{
  "version": 0,
  "bulletin": {
    "type": "info",
    "title": "Thank you for choosing AOSC OS!",
    "body": "We Care about You, Your Development Boards, Your Mysterious CPUs, and Your Pre-historic Antiques."
  },
  "variants": [
    {
      "name": "GNOME",
      "tarballs": [
        {
          "arch": "amd64",
          "date": "20181225",
          "downloadSize": 114514,
          "instSize": 1919810,
          "path": "/os-amd64/gnome/aosc-os_gnome_20181225_amd64.tar.xz"
        },
        {
          "arch": "armel",
          "date": "20181225",
          "downloadSize": 114514,
          "instSize": 1919810,
          "path": "/os-armel/gnome/aosc-os_gnome_20181225_armel.tar.xz"
        }
      ]
    },
    {
      "name": "i3 Window Manager",
      "name@zh-cn": "i3 窗口管理器",
      "tarballs": [
        {
          "arch": "riscv64",
          "date": "20181016",
          "downloadSize": 1102870672,
          "instSize": -1,
          "path": "/os-riscv64/i3wm/aosc-os_i3wm_20181225_riscv64.tar.xz"
        }
      ]
    }
  ],
  "mirrors": [
    {
      "name": "LUG@USTC",
      "name@zh-cn": "中科大 LUG",
      "loc": "Hefei, Anhui, People's Republic of China",
      "loc@zh-cn": "中华人民共和国安徽省合肥市",
      "url": "https://mirrors.ustc.edu.cn/anthon"
    },
    {
      "name": "NLLUG",
      "loc": "Netherlands",
      "loc@nl-nl": "Nederland",
      "loc@zh-cn": "荷兰",
      "url": "https://ftp.nluug.nl/os/Linux/distr/anthon"
    }
  ]
}
```

Note that a valid JSON does not require indentation, nor a sequence of attributes.

### The `Version` Attribute

This attribute represents the API version used in `recipe.json`.

```json
"version": 0
```

`"version"` should increase when a breaking change involves (i.e. version of this documentation has its major version increased). Normally, this should be identical to the major version of this document.
  - A version of `0` represents an implementation of a not-yet-stablized specification, which means the API may break some day. Clients should not support a version 0 recipe once the specification version gets increased to `1`.

### The `Bulletin` Object

A `Bulletin` object represents a bulletin message that the development team want to tell users when they are about to install AOSC OS.

```json
{
  "type": "info",
  "title": "Hi!",
  "body": "Thank you for choosing AOSC OS!"
}
```

- `"type"`: A string value, indicating the type of bulletin. There can be the following possible values:
  - `"none"`: No message. In this case, `"title"` and `"body"` should be ignored.
  - `"info"`: Informative message, can be used for asking for feedback survey.
  - `"warning"`: Warning message, used in cases like potential problem in current tarballs.
  - `"fatal"`: Fatal error message, used in cases like serious problem in anything the user may be using. In this case, the client (installer) should stop its installation process.
- `"title"`: A string value, containing title of the message.
- `"body"`: A string value, containing body of the message.

### The `Variants` Array

This array represents a series of variants (tarball favors) that AOSC OS provides. It contains a list of `Variant` object(s) (see below).

### The `Mirrors` Array

This array represents a series of mirrors for users to choose in order to boost their download speed. It contains a list of `Mirror` object(s) (see below).

### The `Variant` Object

A `Variant` object represents a favor of installation (e.g. image(s) with a desktop environment pre-installed).

```json
{
  "name": "GNOME",
  "tarballs": [
    {
      "arch": "amd64",
      "date": "20181225",
      "downloadSize": 114514,
      "instSize": 1919810,
      "path": "/os-amd64/gnome/aosc-os_gnome_20181225_amd64.tar.xz"
    },
    {
      "arch": "armel",
      "date": "20181225",
      "downloadSize": 2860286264,
      "instSize": -1,
      "path": "/os-armel/kde/aosc-os_kde_20181225_armel.tar.xz"
    }
  ]
}
```

- `"name"`: A string value, describing the name of tarball. Usually this is the name of desktop enviromnent shipped with the distribution, or "Base" for AOSC OS distribution without graphical user interface.
- `"tarballs"`: An array, containing a list of `Tarball` object(s) (see below) ready for the client (installer) to display and download.

### The `Tarball` Object

A `Tarball` object represents a compressed distribution of a specific favor of AOSC OS (namely tarball) in a specific processor architecture (e.g. AMD64).

```json
{
  "arch": "amd64",
  "date": "20181225",
  "downloadSize": 114514,
  "instSize": 1919810,
  "path": "/os-amd64/gnome/aosc-os_gnome_20181225_amd64.tar.xz"
}
```

- `"arch"`: A string value, indicating target processor architecture of the tarball.
- `"date"`: A string value, describing the latest update date of the tarball. Note that this string follows the basic format of [ISO 8601 Data elements and interchange formats](https://en.wikipedia.org/wiki/ISO_8601), namely in the form `YYYYMMDD`, where `Y`, `M`, `D` are respectively year, month, and day.
  - The client (installer) may also implement the expanded year representation, with `+` prefixed in the date string, avoiding [year 10000 problem](https://en.wikipedia.org/wiki/Year_10,000_problem).
- `"downloadSize"`: An integer value, indicating the size for download, in bytes. This field can contain `-1` indicating an unknown download size. In this case the client (installer) may try to figure it out via HTTP `HEAD` request.
- `"instSize"`: An integer value, indicating the size for installation, in bytes. In some cases, this is unknown. This field can also contain a value of `-1` indicating an unknown installation size.
- `"path"`: A string value, containing the path to tarball for download.

### The `Mirror` Object

```json
{
  "name": "LUG@USTC",
  "loc": "Hefei, Anhui, People's Republic of China",
  "url": "https://mirrors.ustc.edu.cn/anthon"
}
```

- `"name"`: A string value, indicating name of the mirror.
- `"loc"`: A string value, indicating location of the mirror. This is mainly used for displaying for users to choose the mirror nearest to their location.
- `"url"`: A string value, containing the URL to the AOSC OS repository mirror (for mirrors that places AOSC OS repository in a subdirectory, it should be included too).

### Localized String Fields

All descriptive string values (e.g. `"name"`, `"title"`) can have supplimental localized values with an [ISO 639](https://en.wikipedia.org/wiki/ISO_639) notation as language suffix. The following is an example of the bulletin object with the original text in English, and translation for Simplified Chinese (`zh-cn`).

```json
{
  "bulletin": {
    "empty": false,
    "type": "info",
    "title": "Thank you for choosing AOSC OS!",
    "title@zh-cn": "感谢你选择 AOSC OS！",
    "body": "We Care about You, Your Development Boards, Your Mysterious CPUs, and Your Pre-historic Antiques.",
    "body@zh-cn": "我们关爱你、你的开发板、你的谜之 CPU，以及你的史前遗产。"
  }
}
```

The localized value is represented as `"<key>@<country_code>": "<value>"`. `<key>` should be the same as the string to be localized. `<country_code>` is an ISO 639-1 laungage code, case insensitive. `<key>` is the localized string value.

Note that `"type": "info"` is not localized, since it is not "descriptive"; the value represents an internal type, so the client should not care about translations on these keys.

ISO 639 has several parts. In this specification, only ISO 639-1 is used; using newer specification is not recommended. This is because [Pango][pango] only recognizes and gives ISO 639-1 language codes. [Pango][pango] also gives all-lowercase language codes. The reference design of DeployKit uses it, so we just comply with it.

[pango]: https://developer.gnome.org/pango/stable

---

End of document.
