import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
    return Markdown(
      data: readme,
      selectable: true,
      shrinkWrap: true,
      styleSheetTheme: MarkdownStyleSheetBaseTheme.platform,
      styleSheet: MarkdownStyleSheet.fromCupertinoTheme(
          CupertinoTheme.of(context).copyWith(
        brightness: MacosTheme.of(context).brightness,
        primaryColor: MacosTheme.of(context).primaryColor,
        scaffoldBackgroundColor: MacosTheme.of(context).canvasColor,
      )),
      extensionSet: md.ExtensionSet.gitHubFlavored,
      blockSyntaxes: const [md.CodeBlockSyntax(), md.TableSyntax()],
      inlineSyntaxes: [
        md.InlineHtmlSyntax(),
        md.CodeSyntax(),
      ],
      imageBuilder: (url, _, __) => url.isScheme('file')
          ? const SizedBox.shrink()
          : Image.network(
              url.toString(),
              fit: BoxFit.cover,
            ),
      onTapLink: (link, _, __) => launchUrlString(link),
    );
  }
}
