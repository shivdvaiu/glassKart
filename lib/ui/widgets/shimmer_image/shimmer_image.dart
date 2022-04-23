import 'package:cached_network_image/cached_network_image.dart';
import 'package:eye_glass_store/ui/resources/app_assets/app_assets.dart';
import 'package:eye_glass_store/ui/widgets/shimmer_image/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CachedImage extends StatefulWidget {
  final String imageUrl;
  final bool isRound;
  final double radius;

  final double height;
  final double width;

  final BoxFit fit;
  final String? placeholder;
  final bool isViewProfile;

  const CachedImage(
    this.imageUrl, {
    this.isRound = true,
    this.radius = 100.0,
    this.isViewProfile = false,
    this.height = 50.0,
    this.width = 50.0,
    this.fit = BoxFit.cover,
    this.placeholder = 'assets/img/user2.jpg',
  });

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  bool hideShimmer = false;
  bool isLoaded = false;
  late final ImageProvider<CachedNetworkImageProvider> image;
  late final Widget shimmerLoader;
  late final Widget errorWidget;

  @override
  void initState() {
    // image = CachedNetworkImageProvider(widget.imageUrl);
    // image.resolve(ImageConfiguration()).addListener(ImageStreamListener(_onImageLoaded));
    _buildLoader();
    super.initState();
  }

  final defaultShimmerBaseColor = Colors.black.withOpacity(0.55);

  ///Base color of the Highlight effect
  final defaultShimmerHighlightColor = Colors.black.withOpacity(0.35);

  ///Base color of the back color
  final defaultShimmerBackColor = Colors.black.withOpacity(0.70);

  void _buildLoader() {
    shimmerLoader = ImageShimmerWidget(
      width: widget.width,
      height: widget.height,
      shimmerDirection: ShimmerDirection.ltr,
      shimmerDuration: const Duration(milliseconds: 1000),
      baseColor: Colors.black.withOpacity(0.35),
      highlightColor: Colors.white10,
      backColor: Colors.white,
    );
    errorWidget = Container(
      height: widget.isRound ? widget.radius : widget.height,
      width: widget.isRound ? widget.radius : widget.width,
      decoration: BoxDecoration(
        shape: widget.isRound ? BoxShape.circle : BoxShape.rectangle,
        
      ),
    );
  }

  void _onImageLoaded(ImageInfo info, bool k) {
    if (mounted) if (!isLoaded) {
      setState(() {
        isLoaded = true;
        Future.delayed(const Duration(seconds: 1), () {
          hideShimmer = true;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // image.resolve(ImageConfiguration()).removeListener(ImageStreamListener(_onImageLoaded));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SizedBox(
      height: widget.isRound ? widget.radius : widget.height,
      width: widget.isRound ? widget.radius : widget.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: widget.fit,
          alignment: Alignment.center,
          useOldImageOnUrlChange: true,
          cacheKey: widget.imageUrl,
          placeholder: (context, url) => shimmerLoader,
          errorWidget: (context, url, error) => errorWidget,
        ),
      ),
    );
  }
}

class AnimatedDecorationImage extends DecorationImage {
  /// The [image], [alignment], [repeat], and [matchTextDirection] arguments
  /// must not be null.
  AnimatedDecorationImage({
    required Animation<dynamic> colorAnimation,
    required ImageProvider image,
    BoxFit? fit,
    AlignmentGeometry? alignment = Alignment.center,
    Rect? centerSlice,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
  })  : assert(image != null),
        assert(alignment != null),
        assert(repeat != null),
        assert(matchTextDirection != null),
        super(
          image: image,
          colorFilter: ColorFilter.mode(colorAnimation.value, BlendMode.color),
          fit: fit,
          alignment: alignment!,
          centerSlice: centerSlice,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
        );
}
