import '../../domain/entities/wallpaper_preview.dart';

class WallpaperPreviewModel extends WallpaperPreview {
  const WallpaperPreviewModel({
    required super.quote,
    required super.layoutStyle,
    required super.textureStrength,
    required super.blurStrength,
    required super.palette,
    required super.fontFamily,
  });

  factory WallpaperPreviewModel.fromEntity(WallpaperPreview preview) {
    return WallpaperPreviewModel(
      quote: preview.quote,
      layoutStyle: preview.layoutStyle,
      textureStrength: preview.textureStrength,
      blurStrength: preview.blurStrength,
      palette: preview.palette,
      fontFamily: preview.fontFamily,
    );
  }

  factory WallpaperPreviewModel.fromMap(Map<String, dynamic> map) {
    return WallpaperPreviewModel(
      quote: map['quote'] as String? ?? '',
      layoutStyle: map['layoutStyle'] as String? ?? 'center stack',
      textureStrength: (map['textureStrength'] as num?)?.toDouble() ?? 0.35,
      blurStrength: (map['blurStrength'] as num?)?.toDouble() ?? 0.2,
      palette: (map['palette'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item as int? ?? 0xFF111111)
          .toList(),
      fontFamily: map['fontFamily'] as String? ?? 'Outfit',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quote': quote,
      'layoutStyle': layoutStyle,
      'textureStrength': textureStrength,
      'blurStrength': blurStrength,
      'palette': palette,
      'fontFamily': fontFamily,
    };
  }
}
