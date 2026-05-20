import 'package:equatable/equatable.dart';

class WallpaperPreview extends Equatable {
  const WallpaperPreview({
    required this.quote,
    required this.layoutStyle,
    required this.textureStrength,
    required this.blurStrength,
    required this.palette,
    required this.fontFamily,
  });

  final String quote;
  final String layoutStyle;
  final double textureStrength;
  final double blurStrength;
  final List<int> palette;
  final String fontFamily;

  WallpaperPreview copyWith({
    String? quote,
    String? layoutStyle,
    double? textureStrength,
    double? blurStrength,
    List<int>? palette,
    String? fontFamily,
  }) {
    return WallpaperPreview(
      quote: quote ?? this.quote,
      layoutStyle: layoutStyle ?? this.layoutStyle,
      textureStrength: textureStrength ?? this.textureStrength,
      blurStrength: blurStrength ?? this.blurStrength,
      palette: palette ?? this.palette,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        quote,
        layoutStyle,
        textureStrength,
        blurStrength,
        palette,
        fontFamily,
      ];
}
