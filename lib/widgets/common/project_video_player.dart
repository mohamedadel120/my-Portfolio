import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../core/constants/app_colors.dart';
import '../../utils/device_utils.dart';

class ProjectVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isVisible;

  const ProjectVideoPlayer({
    super.key,
    required this.videoUrl,
    this.isVisible = false,
  });

  @override
  State<ProjectVideoPlayer> createState() => _ProjectVideoPlayerState();
}

class _ProjectVideoPlayerState extends State<ProjectVideoPlayer> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _hasError = false;
  bool _isLowSpec = false;

  @override
  void initState() {
    super.initState();
    // Initialize video immediately only on desktop
    // On mobile, delay initialization until visible
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLowSpec = DeviceUtils.isLowSpecDevice(context);

    if (!_isLowSpec && _controller == null) {
      // Desktop: Initialize immediately
      _initializeVideo();
    }
  }

  @override
  void didUpdateWidget(ProjectVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // On low-spec: Only initialize when visible for the first time
    if (_isLowSpec && widget.isVisible && _controller == null) {
      _initializeVideo();
    }

    if (widget.isVisible != oldWidget.isVisible && _initialized && !_hasError) {
      if (widget.isVisible) {
        _controller?.play();
      } else {
        _controller?.pause();
      }
    }
  }

  Future<void> _initializeVideo() async {
    try {
      late VideoPlayerController controller;

      if (widget.videoUrl.startsWith('http')) {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
        );
      } else {
        controller = VideoPlayerController.asset(widget.videoUrl);
      }

      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0.0); // Mute by default

      if (widget.isVisible) {
        await controller.play();
      }

      if (mounted) {
        setState(() {
          _controller = controller;
          _initialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.error_outline, color: Colors.white, size: 40),
        ),
      );
    }

    // On low-spec, show play button if not yet initialized
    if (_isLowSpec && !_initialized) {
      return Container(
        color: Colors.black,
        child: Center(
          child: IconButton(
            onPressed: _initializeVideo,
            iconSize: 60,
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      );
    }

    if (!_initialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }
}
