[![License](https://img.shields.io/github/license/arthurpalves/badgy)](https://github.com/arthurpalves/badgy/blob/master/LICENSE)
[![Language](https://img.shields.io/badge/language-swift-orange.svg?style=flat)](https://developer.apple.com/swift)
![Platform](https://img.shields.io/badge/platform-osx-lightgrey)

<p align="center">
<img src="Assets/badgy.png" title="Badgy">
</p>

<p align="center">Badgy is a command line tool that creates variants of your icon by adding badge overlays.</p>

## Features

- ✅ Small (square) and long (rectangular) labels
- ✅ Position it on `top, left, bottom, right, topLeft, topRight, bottomLeft, bottomRight, center`
- ✅ Supports rotation (long badge only)
- ✅ Converts your icon to different sizes already
- ✅ 🚀 Ability to automatically replace your `.appiconasset`, mainting the same name and sizes

## Disclaimer

This tool is **NOT** meant to create production ready icons. As I see myself constantly using at least 4 variants of the same application for B2B customers (think of 1 environment for DEV, QA, UAT, PROD and more), I quickly created this tool to differentiate the application icon for those variants.

There are many things that might not work as you expect, and there are many others that you wish this could do. Feel free to contribute to the project and make it better.

## Dependency

This tool depends on `ImageMagick`. If not installed with `brew` make sure to install this dependency yourself:
```sh
brew install imagemagick
```

## Installation

### Homebrew (recommended)

```sh
brew tap arthurpalves/formulae
brew install badgy
```

### [Mint](https://github.com/yonaskolb/Mint)

```sh
mint install arthurpalves/badgy
```

### Make

```sh
git clone https://github.com/arthurpalves/badgy.git
cd badgy
make install
```
### Swift Package Manager

#### Use as CLI

```sh
git clone https://github.com/arthurpalves/badgy.git
cd badgy
swift run badgy
```

## Usage

```sh
Usage: badgy <command> [options]

A command-line tool to add labels to your app icon

Commands:
  small           Add small square label to app icon
  long            Add rectangular label to app icon
  help            Prints help information
  version         Prints the current version of this app
```

### Small badge

Small is a square badge containing only 1 character.

```sh
Usage: badgy small <char> <icon> [options]

Add small square label to app icon

Options:
  -c, --color <value>         Specify badge color with a hexadecimal color code
  -h, --help                  Show help information
  -p, --position <value>      Position on which to place the badge
  -r, --replace               Indicates Badgy should replace the input icon
  -t, --tint-color <value>    Specify badge text/tint color with a hexadecimal color code
  -v, --verbose               Log tech details for nerds
```

#### Example
```sh
badgy small A ~/MyIcon.png --position topRight
```
<p align="center">
<img src="Assets/a_small_sample.png" title="badgy small">
</p>

### Long badge

Long is a rectangular badge containing up to 4 characters.

```sh
Usage: badgy long <labelText> <icon> [options]

Add rectangular label to app icon

Options:
  -a, --angle <value>         Rotation angle of the badge
  -c, --color <value>         Specify badge color with a hexadecimal color code
  -h, --help                  Show help information
  -p, --position <value>      Position on which to place the badge
  -r, --replace               Indicates Badgy should replace the input icon
  -t, --tint-color <value>    Specify badge text/tint color with a hexadecimal color code
  -v, --verbose               Log tech details for nerds
```

#### Example
```sh
badgy long BETA ~/MyIcon.png --angle 15 --position bottom
```
<p align="center">
<img src="Assets/beta_long_sample.png" title="badgy long">
</p>

### Choose your colors

You can change the badge color and the tint/text color with `-c, --color` and `-t, -tint-color`.
If not specified, as in the examples above, the badge color is randomly selected while the tint color is always white.

#### Example
```sh
badgy long TEST ~/MyIcon.png --angle 15 --position bottom --color '#FFD700' --tint-color '#8B7500'
```
<p align="center">
<img src="Assets/test_long_sample.png" title="badgy long color">
</p>

If a human readable color format is your dub, then check out a full list of [supported named colors](https://imagemagick.org/script/color.php#color_names).

### Replace your icon directly

The acceptable formats for your input icon are: `.png`, `.jpg` and `.appiconasset`.
If the later is used, Badgy will find the largest image available in the asset to serve as input.

#### `--replace`

Replace is a flag that you can use alongside your `.appiconasset` input, it will iterate over all images available in the asset and convert the largest icon to the respective size, this allows Badgy to maintain the same amount of files, same names and same sizes.

✅ Perfect for any icon set -> iOS, iPadOS, tvOS, macOS

```sh
badgy long TEST MyProjectSource/Assets.xcassets/AppIcon.appiconasset --angle 15 --position bottom --replace
```

## License

Badgy is released under the MIT license. See [LICENSE](https://github.com/arthurpalves/badgy/blob/master/LICENSE) for more information.
