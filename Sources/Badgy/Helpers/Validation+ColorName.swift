//
// Validation+ColorName.swift
// Badgy
//
// MIT License
//
// Copyright (c) 2020 Arthur Alves
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import SwiftCLI

extension Validation where T == String {
    /// Check whether the `input` is a known color name
    static func isColorName(_ input: String) -> Bool {
        return colorNames.contains(input)
    }

    /// The set below provides a list of named colors recognized by
    /// [ImageMagick as color names](https://imagemagick.org/script/color.php#color_names)
    private static let colorNames = Set([
        "snow", "snow1", "snow2", "RosyBrown1", "RosyBrown2", "snow3", "LightCoral",
        "IndianRed1", "RosyBrown3", "IndianRed2", "RosyBrown", "brown1", "firebrick1",
        "brown2", "IndianRed", "IndianRed3", "firebrick2", "snow4", "brown3", "red",
        "red1", "RosyBrown4", "firebrick3", "red2", "firebrick", "brown", "red3",
        "IndianRed4", "brown4", "firebrick4", "DarkRed", "red4", "maroon", "LightPink1",
        "LightPink3", "LightPink4", "LightPink2", "LightPink", "pink", "crimson",
        "pink1", "pink2", "pink3", "pink4", "PaleVioletRed4", "PaleVioletRed",
        "PaleVioletRed2", "PaleVioletRed1", "PaleVioletRed3", "LavenderBlush",
        "LavenderBlush1", "LavenderBlush3", "LavenderBlush2", "LavenderBlush4",
        "maroon", "HotPink3", "VioletRed3", "VioletRed1", "VioletRed2", "VioletRed4",
        "HotPink2", "HotPink1", "HotPink4", "HotPink", "DeepPink", "DeepPink1",
        "DeepPink2", "DeepPink3", "DeepPink4", "maroon1", "maroon2", "maroon3",
        "maroon4", "MediumVioletRed", "VioletRed", "orchid2", "orchid", "orchid1",
        "orchid3", "orchid4", "thistle1", "thistle2", "plum1", "plum2", "thistle",
        "thistle3", "plum", "violet", "plum3", "thistle4", "fuchsia", "magenta",
        "magenta1", "plum4", "magenta2", "magenta3", "DarkMagenta", "magenta4",
        "purple", "MediumOrchid", "MediumOrchid1", "MediumOrchid2", "MediumOrchid3",
        "MediumOrchid4", "DarkViolet", "DarkOrchid", "DarkOrchid1", "DarkOrchid3",
        "DarkOrchid2", "DarkOrchid4", "purple", "indigo", "BlueViolet", "purple2",
        "purple3", "purple4", "purple1", "MediumPurple", "MediumPurple1",
        "MediumPurple2", "MediumPurple3", "MediumPurple4", "DarkSlateBlue",
        "LightSlateBlue", "MediumSlateBlue", "SlateBlue", "SlateBlue1", "SlateBlue2",
        "SlateBlue3", "SlateBlue4", "GhostWhite", "lavender", "blue", "blue1", "blue2",
        "blue3", "MediumBlue", "blue4", "DarkBlue", "MidnightBlue", "navy", "NavyBlue",
        "RoyalBlue", "RoyalBlue1", "RoyalBlue2", "RoyalBlue3", "RoyalBlue4",
        "CornflowerBlue", "LightSteelBlue", "LightSteelBlue1", "LightSteelBlue2",
        "LightSteelBlue3", "LightSteelBlue4", "SlateGray4", "SlateGray1", "SlateGray2",
        "SlateGray3", "LightSlateGray", "LightSlateGrey", "SlateGray", "SlateGrey",
        "DodgerBlue", "DodgerBlue1", "DodgerBlue2", "DodgerBlue4", "DodgerBlue3",
        "AliceBlue", "SteelBlue4", "SteelBlue", "SteelBlue1", "SteelBlue2",
        "SteelBlue3", "SkyBlue4", "SkyBlue1", "SkyBlue2", "SkyBlue3", "LightSkyBlue",
        "LightSkyBlue4", "LightSkyBlue1", "LightSkyBlue2", "LightSkyBlue3", "SkyBlue",
        "LightBlue3", "DeepSkyBlue", "DeepSkyBlue1", "DeepSkyBlue2", "DeepSkyBlue4",
        "DeepSkyBlue3", "LightBlue1", "LightBlue2", "LightBlue", "LightBlue4",
        "PowderBlue", "CadetBlue1", "CadetBlue2", "CadetBlue3", "CadetBlue4",
        "turquoise1", "turquoise2", "turquoise3", "turquoise4", "cadet", "CadetBlue",
        "DarkTurquoise", "azure", "azure1", "LightCyan", "LightCyan1", "azure2",
        "LightCyan2", "PaleTurquoise1", "PaleTurquoise", "PaleTurquoise2",
        "DarkSlateGray1", "azure3", "LightCyan3", "DarkSlateGray2", "PaleTurquoise3",
        "DarkSlateGray3", "azure4", "LightCyan4", "aqua", "cyan", "cyan1",
        "PaleTurquoise4", "cyan2", "DarkSlateGray4", "cyan3", "cyan4", "DarkCyan",
        "teal", "DarkSlateGray", "DarkSlateGrey", "MediumTurquoise", "LightSeaGreen",
        "turquoise", "aquamarine4", "aquamarine", "aquamarine1", "aquamarine2",
        "aquamarine3", "MediumAquamarine", "MediumSpringGreen", "MintCream",
        "SpringGreen", "SpringGreen1", "SpringGreen2", "SpringGreen3", "SpringGreen4",
        "MediumSeaGreen", "SeaGreen", "SeaGreen3", "SeaGreen1", "SeaGreen4",
        "SeaGreen2", "MediumForestGreen", "honeydew", "honeydew1", "honeydew2",
        "DarkSeaGreen1", "DarkSeaGreen2", "PaleGreen1", "PaleGreen", "honeydew3",
        "LightGreen", "PaleGreen2", "DarkSeaGreen3", "DarkSeaGreen", "PaleGreen3",
        "honeydew4", "green1", "lime", "LimeGreen", "DarkSeaGreen4", "green2",
        "PaleGreen4", "green3", "ForestGreen", "green4", "green", "DarkGreen",
        "LawnGreen", "chartreuse", "chartreuse1", "chartreuse2", "chartreuse3",
        "chartreuse4", "GreenYellow", "DarkOliveGreen3", "DarkOliveGreen1",
        "DarkOliveGreen2", "DarkOliveGreen4", "DarkOliveGreen", "OliveDrab",
        "OliveDrab1", "OliveDrab2", "OliveDrab3", "YellowGreen", "OliveDrab4", "ivory",
        "ivory1", "LightYellow", "LightYellow1", "beige", "ivory2",
        "LightGoldenrodYellow", "LightYellow2", "ivory3", "LightYellow3", "ivory4",
        "LightYellow4", "yellow", "yellow1", "yellow2", "yellow3", "yellow4", "olive",
        "DarkKhaki", "khaki2", "LemonChiffon4", "khaki1", "khaki3", "khaki4",
        "PaleGoldenrod", "LemonChiffon", "LemonChiffon1", "khaki", "LemonChiffon3",
        "LemonChiffon2", "MediumGoldenRod", "cornsilk4", "gold", "gold1", "gold2",
        "gold3", "gold4", "LightGoldenrod", "LightGoldenrod4", "LightGoldenrod1",
        "LightGoldenrod3", "LightGoldenrod2", "cornsilk3", "cornsilk2", "cornsilk",
        "cornsilk1", "goldenrod", "goldenrod1", "goldenrod2", "goldenrod3",
        "goldenrod4", "DarkGoldenrod", "DarkGoldenrod1", "DarkGoldenrod2",
        "DarkGoldenrod3", "DarkGoldenrod4", "FloralWhite", "wheat2", "OldLace", "wheat",
        "wheat1", "wheat3", "orange", "orange1", "orange2", "orange3", "orange4",
        "wheat4", "moccasin", "PapayaWhip", "NavajoWhite3", "BlanchedAlmond",
        "NavajoWhite", "NavajoWhite1", "NavajoWhite2", "NavajoWhite4", "AntiqueWhite4",
        "AntiqueWhite", "tan", "bisque4", "burlywood", "AntiqueWhite2", "burlywood1",
        "burlywood3", "burlywood2", "AntiqueWhite1", "burlywood4", "AntiqueWhite3",
        "DarkOrange", "bisque2", "bisque", "bisque1", "bisque3", "DarkOrange1", "linen",
        "DarkOrange2", "DarkOrange3", "DarkOrange4", "peru", "tan1", "tan2", "tan3",
        "tan4", "PeachPuff", "PeachPuff1", "PeachPuff4", "PeachPuff2", "PeachPuff3",
        "SandyBrown", "seashell4", "seashell2", "seashell3", "chocolate", "chocolate1",
        "chocolate2", "chocolate3", "chocolate4", "SaddleBrown", "seashell",
        "seashell1", "sienna4", "sienna", "sienna1", "sienna2", "sienna3",
        "LightSalmon3", "LightSalmon", "LightSalmon1", "LightSalmon4", "LightSalmon2",
        "coral", "OrangeRed", "OrangeRed1", "OrangeRed2", "OrangeRed3", "OrangeRed4",
        "DarkSalmon", "salmon1", "salmon2", "salmon3", "salmon4", "coral1", "coral2",
        "coral3", "coral4", "tomato4", "tomato", "tomato1", "tomato2", "tomato3",
        "MistyRose4", "MistyRose2", "MistyRose", "MistyRose1", "salmon", "MistyRose3",
        "white", "gray100", "grey100", "grey100", "gray99", "grey99", "gray98",
        "grey98", "gray97", "grey97", "gray96", "grey96", "WhiteSmoke", "gray95",
        "grey95", "gray94", "grey94", "gray93", "grey93", "gray92", "grey92", "gray91",
        "grey91", "gray90", "grey90", "gray89", "grey89", "gray88", "grey88", "gray87",
        "grey87", "gainsboro", "gray86", "grey86", "gray85", "grey85", "gray84",
        "grey84", "gray83", "grey83", "LightGray", "LightGrey", "gray82", "grey82",
        "gray81", "grey81", "gray80", "grey80", "gray79", "grey79", "gray78", "grey78",
        "gray77", "grey77", "gray76", "grey76", "silver", "gray75", "grey75", "gray74",
        "grey74", "gray73", "grey73", "gray72", "grey72", "gray71", "grey71", "gray70",
        "grey70", "gray69", "grey69", "gray68", "grey68", "gray67", "grey67",
        "DarkGray", "DarkGrey", "gray66", "grey66", "gray65", "grey65", "gray64",
        "grey64", "gray63", "grey63", "gray62", "grey62", "gray61", "grey61", "gray60",
        "grey60", "gray59", "grey59", "gray58", "grey58", "gray57", "grey57", "gray56",
        "grey56", "gray55", "grey55", "gray54", "grey54", "gray53", "grey53", "gray52",
        "grey52", "gray51", "grey51", "fractal", "gray50", "grey50", "gray", "gray49",
        "grey49", "gray48", "grey48", "gray47", "grey47", "gray46", "grey46", "gray45",
        "grey45", "gray44", "grey44", "gray43", "grey43", "gray42", "grey42", "DimGray",
        "DimGrey", "gray41", "grey41", "gray40", "grey40", "gray39", "grey39", "gray38",
        "grey38", "gray37", "grey37", "gray36", "grey36", "gray35", "grey35", "gray34",
        "grey34", "gray33", "grey33", "gray32", "grey32", "gray31", "grey31", "gray30",
        "grey30", "gray29", "grey29", "gray28", "grey28", "gray27", "grey27", "gray26",
        "grey26", "gray25", "grey25", "gray24", "grey24", "gray23", "grey23", "gray22",
        "grey22", "gray21", "grey21", "gray20", "grey20", "gray19", "grey19", "gray18",
        "grey18", "gray17", "grey17", "gray16", "grey16", "gray15", "grey15", "gray14",
        "grey14", "gray13", "grey13", "gray12", "grey12", "gray11", "grey11", "gray10",
        "grey10", "gray9", "grey9", "gray8", "grey8", "gray7", "grey7", "gray6",
        "grey6", "gray5", "grey5", "gray4", "grey4", "gray3", "grey3", "gray2", "grey2",
        "gray1", "grey1", "black", "gray0", "grey0", "opaque", "none", "transparent"
    ])
}
