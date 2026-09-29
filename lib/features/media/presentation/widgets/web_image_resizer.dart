import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

class WebImageResizer {
  static Future<Uint8List> resizeImage(
    Uint8List inputBytes, {
    int maxWidth = 1920,
    double quality = 0.82,
  }) async {
    final completer = Completer<Uint8List>();

    final blob = html.Blob([inputBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final imageElement = html.ImageElement();

    imageElement.src = url;
    imageElement.onLoad.listen((_) {
      int width = imageElement.width!;
      int height = imageElement.height!;

      if (width > maxWidth) {
        height = ((maxWidth / width) * height).round();
        width = maxWidth;
      }

      final canvas = html.CanvasElement(width: width, height: height);
      final ctx = canvas.context2D;
      ctx.drawImageScaled(imageElement, 0, 0, width, height);

      final dataUrl = canvas.toDataUrl('image/jpeg', quality);
      final base64String = dataUrl.split(',').last;

      html.Url.revokeObjectUrl(url);
      completer.complete(
        Uint8List.fromList(html.window.atob(base64String).codeUnits),
      );
    });

    imageElement.onError.listen((_) {
      html.Url.revokeObjectUrl(url);
      completer.complete(inputBytes);
    });

    return completer.future;
  }
}
