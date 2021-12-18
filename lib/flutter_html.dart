library flutter_html;

import 'package:flutter/material.dart';
import 'package:flutter_html/custom_render.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/src/html_elements.dart';
import 'package:flutter_html/style.dart';
import 'package:html/dom.dart' as dom;

//export render context api
export 'package:flutter_html/html_parser.dart';
//export render context api
export 'package:flutter_html/html_parser.dart';
export 'package:flutter_html/custom_render.dart';
//export src for advanced custom render uses (e.g. casting context.tree)
export 'package:flutter_html/src/anchor.dart';
export 'package:flutter_html/src/interactable_element.dart';
export 'package:flutter_html/src/layout_element.dart';
export 'package:flutter_html/src/replaced_element.dart';
export 'package:flutter_html/src/styled_element.dart';
//export style api
export 'package:flutter_html/style.dart';

class Html extends StatefulWidget {
  /// The `Html` widget takes HTML as input and displays a RichText
  /// tree of the parsed HTML content.
  ///
  /// **Attributes**
  /// **data** *required* takes in a String of HTML data (required only for `Html` constructor).
  /// **document** *required* takes in a Document of HTML data (required only for `Html.fromDom` constructor).
  ///
  /// **onLinkTap** This function is called whenever a link (`<a href>`)
  /// is tapped.
  /// **customRender** This function allows you to return your own widgets
  /// for existing or custom HTML tags.
  /// See [its wiki page](https://github.com/Sub6Resources/flutter_html/wiki/All-About-customRender) for more info.
  ///
  /// **onImageError** This is called whenever an image fails to load or
  /// display on the page.
  ///
  /// **shrinkWrap** This makes the Html widget take up only the width it
  /// needs and no more.
  ///
  /// **onImageTap** This is called whenever an image is tapped.
  ///
  /// **tagsList** Tag names in this array will be the only tags rendered. By default all supported HTML tags are rendered.
  ///
  /// **style** Pass in the style information for the Html here.
  /// See [its wiki page](https://github.com/Sub6Resources/flutter_html/wiki/Style) for more info.
  Html({
    Key? key,
    GlobalKey? anchorKey,
    required this.data,
    this.onLinkTap,
    this.onAnchorTap,
    this.customRenders = const {},
    this.onCssParseError,
    this.onImageError,
    this.shrinkWrap = false,
    this.onImageTap,
    this.tagsList = const [],
    this.style = const {},
  }) : document = null,
        assert (data != null),
        _anchorKey = anchorKey ?? GlobalKey(),
        super(key: key);

  Html.fromDom({
    Key? key,
    GlobalKey? anchorKey,
    @required this.document,
    this.onLinkTap,
    this.onAnchorTap,
    this.customRenders = const {},
    this.onCssParseError,
    this.onImageError,
    this.shrinkWrap = false,
    this.onImageTap,
    this.tagsList = const [],
    this.style = const {},
  }) : data = null,
        assert(document != null),
        _anchorKey = anchorKey ?? GlobalKey(),
        super(key: key);

  /// A unique key for this Html widget to ensure uniqueness of anchors
  final GlobalKey _anchorKey;

  /// The HTML data passed to the widget as a String
  final String? data;

  /// The HTML data passed to the widget as a pre-processed [dom.Document]
  final dom.Document? document;

  /// A function that defines what to do when a link is tapped
  final OnTap? onLinkTap;

  /// A function that defines what to do when an anchor link is tapped. When this value is set,
  /// the default anchor behaviour is overwritten.
  final OnTap? onAnchorTap;

  /// A function that defines what to do when CSS fails to parse
  final OnCssParseError? onCssParseError;

  /// A function that defines what to do when an image errors
  final ImageErrorListener? onImageError;

  /// A parameter that should be set when the HTML widget is expected to be
  /// flexible
  final bool shrinkWrap;

  /// A function that defines what to do when an image is tapped
  final OnTap? onImageTap;

  /// A list of HTML tags that are the only tags that are rendered. By default, this list is empty and all supported HTML tags are rendered.
  final List<String> tagsList;

  /// Either return a custom widget for specific node types or return null to
  /// fallback to the default rendering.
  final Map<CustomRenderMatcher, CustomRender> customRenders;

  /// An API that allows you to override the default style for any HTML element
  final Map<String, Style> style;

  static List<String> get tags => new List<String>.from(STYLED_ELEMENTS)
    ..addAll(INTERACTABLE_ELEMENTS)
    ..addAll(REPLACED_ELEMENTS)
    ..addAll(LAYOUT_ELEMENTS)
    ..addAll(TABLE_CELL_ELEMENTS)
    ..addAll(TABLE_DEFINITION_ELEMENTS)
    ..addAll(EXTERNAL_ELEMENTS);

  @override
  State<StatefulWidget> createState() => _HtmlState();
}

class _HtmlState extends State<Html> {
  late final dom.Document doc;

  @override
  void initState() {
    super.initState();
    doc =
    widget.data != null ? HtmlParser.parseHTML(widget.data!) : widget.document!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.shrinkWrap ? null : MediaQuery.of(context).size.width,
      child: HtmlParser(
        key: widget._anchorKey,
        htmlData: doc,
        onLinkTap: widget.onLinkTap,
        onAnchorTap: widget.onAnchorTap,
        onImageTap: widget.onImageTap,
        onCssParseError: widget.onCssParseError,
        onImageError: widget.onImageError,
        shrinkWrap: widget.shrinkWrap,
        selectable: false,
        style: widget.style,
        customRenders: {}
          ..addAll(widget.customRenders)
          ..addAll(defaultRenders),
        tagsList: widget.tagsList.isEmpty ? Html.tags : widget.tagsList,
      ),
    );
  }
}

class SelectableHtml extends StatefulWidget {
  /// The `SelectableHtml` widget takes HTML as input and displays a RichText
  /// tree of the parsed HTML content (which is selectable)
  ///
  /// **Attributes**
  /// **data** *required* takes in a String of HTML data (required only for `Html` constructor).
  /// **document** *required* takes in a Document of HTML data (required only for `Html.fromDom` constructor).
  ///
  /// **onLinkTap** This function is called whenever a link (`<a href>`)
  /// is tapped.
  ///
  /// **onAnchorTap** This function is called whenever an anchor (#anchor-id)
  /// is tapped.
  ///
  /// **tagsList** Tag names in this array will be the only tags rendered. By default, all tags that support selectable content are rendered.
  ///
  /// **style** Pass in the style information for the Html here.
  /// See [its wiki page](https://github.com/Sub6Resources/flutter_html/wiki/Style) for more info.
  ///
  /// **PLEASE NOTE**
  ///
  /// There are a few caveats due to Flutter [#38474](https://github.com/flutter/flutter/issues/38474):
  ///
  /// 1. The list of tags that can be rendered is significantly reduced.
  /// Key omissions include no support for images/video/audio, table, and ul/ol because they all require widgets and `WidgetSpan`s.
  ///
  /// 2. No support for `customRender`, `customImageRender`, `onImageError`, `onImageTap`, `onMathError`, and `navigationDelegateForIframe`.
  ///
  /// 3. Styling support is significantly reduced. Only text-related styling works
  /// (e.g. bold or italic), while container related styling (e.g. borders or padding/margin)
  /// do not work because we can't use the `ContainerSpan` class (it needs an enclosing `WidgetSpan`).

  SelectableHtml({
    Key? key,
    GlobalKey? anchorKey,
    required this.data,
    this.onLinkTap,
    this.onAnchorTap,
    this.onCssParseError,
    this.shrinkWrap = false,
    this.style = const {},
    this.customRenders = const {},
    this.tagsList = const [],
    this.selectionControls,
    this.scrollPhysics,
  }) : document = null,
        assert(data != null),
        _anchorKey = anchorKey ?? GlobalKey(),
        super(key: key);

  SelectableHtml.fromDom({
    Key? key,
    GlobalKey? anchorKey,
    required this.document,
    this.onLinkTap,
    this.onAnchorTap,
    this.onCssParseError,
    this.shrinkWrap = false,
    this.style = const {},
    this.customRenders = const {},
    this.tagsList = const [],
    this.selectionControls,
    this.scrollPhysics,
  }) : data = null,
        assert(document != null),
        _anchorKey = anchorKey ?? GlobalKey(),
        super(key: key);

  /// A unique key for this Html widget to ensure uniqueness of anchors
  final GlobalKey _anchorKey;

  /// The HTML data passed to the widget as a String
  final String? data;

  /// The HTML data passed to the widget as a pre-processed [dom.Document]
  final dom.Document? document;

  /// A function that defines what to do when a link is tapped
  final OnTap? onLinkTap;

  /// A function that defines what to do when an anchor link is tapped. When this value is set,
  /// the default anchor behaviour is overwritten.
  final OnTap? onAnchorTap;

  /// A function that defines what to do when CSS fails to parse
  final OnCssParseError? onCssParseError;

  /// A parameter that should be set when the HTML widget is expected to be
  /// flexible
  final bool shrinkWrap;

  /// A list of HTML tags that are the only tags that are rendered. By default, this list is empty and all supported HTML tags are rendered.
  final List<String> tagsList;

  /// An API that allows you to override the default style for any HTML element
  final Map<String, Style> style;

  /// Custom Selection controls allows you to override default toolbar and build custom toolbar
  /// options
  final TextSelectionControls? selectionControls;

  /// Allows you to override the default scrollPhysics for [SelectableText.rich]
  final ScrollPhysics? scrollPhysics;

  /// Either return a custom widget for specific node types or return null to
  /// fallback to the default rendering.
  final Map<CustomRenderMatcher, SelectableCustomRender> customRenders;

  static List<String> get tags => new List<String>.from(SELECTABLE_ELEMENTS);

  @override
  State<StatefulWidget> createState() => _SelectableHtmlState();
}

class _SelectableHtmlState extends State<SelectableHtml> {
  late final dom.Document doc;

  @override
  void initState() {
    super.initState();
    doc =
    widget.data != null ? HtmlParser.parseHTML(widget.data!) : widget.document!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.shrinkWrap ? null : MediaQuery.of(context).size.width,
      child: HtmlParser(
        key: widget._anchorKey,
        htmlData: doc,
        onLinkTap: widget.onLinkTap,
        onAnchorTap: widget.onAnchorTap,
        onImageTap: null,
        onCssParseError: widget.onCssParseError,
        onImageError: null,
        shrinkWrap: widget.shrinkWrap,
        selectable: true,
        style: widget.style,
        customRenders: {}
          ..addAll(widget.customRenders)
          ..addAll(defaultRenders),
        tagsList: widget.tagsList.isEmpty ? SelectableHtml.tags : widget.tagsList,
        selectionControls: widget.selectionControls,
        scrollPhysics: widget.scrollPhysics,
      ),
    );
  }
}
