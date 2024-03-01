import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher_string.dart';

class PackageReadMeMarkdown extends StatelessWidget {
  const PackageReadMeMarkdown({
    super.key,
    required this.readme,
  });
  final String readme;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: readme,
      selectable: true,
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      styleSheetTheme: MarkdownStyleSheetBaseTheme.platform,
      styleSheet: MarkdownStyleSheet.fromCupertinoTheme(
          CupertinoTheme.of(context).copyWith(
        brightness: MacosTheme.of(context).brightness,
        primaryColor: MacosTheme.of(context).primaryColor,
        scaffoldBackgroundColor: MacosTheme.of(context).canvasColor,
      )),
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        <md.InlineSyntax>[
          md.EmojiSyntax(),
          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
        ],
      ),
      blockSyntaxes: const [
        md.CodeBlockSyntax(),
        md.TableSyntax(),
        md.FencedCodeBlockSyntax()
      ],
      inlineSyntaxes: [
        md.InlineHtmlSyntax(),
        md.CodeSyntax(),
        md.ImageSyntax(),
        md.LinkSyntax(),
      ],
      imageBuilder: (url, _, __) => url.isScheme('file')
          ? const SizedBox.shrink()
          : url.path.endsWith('.svg')
              ? SvgPicture.network(url.origin + url.path)
              : Image.network(url.origin + url.path),
      onTapLink: (link, _, __) => launchUrlString(link),
    );
  }
}
