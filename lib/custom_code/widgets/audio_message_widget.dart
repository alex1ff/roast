// Automatic FlutterFlow imports
import '/backend/backend.dart';
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioMessageWidget extends StatefulWidget {
  const AudioMessageWidget({
    super.key,
    this.width,
    this.height,
    required this.audioUrl,
  });

  final double? width;
  final double? height;
  final String audioUrl;

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  static const Color _inactiveColor = Color(0xFF1C1C1C);
  static const Color _activeColor = Color(0xFFFB7513);

  late final AudioPlayer _audioPlayer;
  late final StreamSubscription<PlayerState> _playerStateSub;
  late final StreamSubscription<Duration> _durationSub;
  late final StreamSubscription<Duration> _positionSub;

  bool _isPlaying = false;
  bool _startedOnce = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  List<double> _barHeights = const [];
  int _lastBarCount = -1;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _playerStateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
        if (state == PlayerState.completed) {
          _isPlaying = false;
          _position = _duration;
        }
      });
    });

    _durationSub = _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() => _duration = duration);
    });

    _positionSub = _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });
  }

  @override
  void didUpdateWidget(covariant AudioMessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioUrl != widget.audioUrl) {
      _resetPlaybackState();
    }
  }

  void _resetPlaybackState() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _startedOnce = false;
      _duration = Duration.zero;
      _position = Duration.zero;
    });
  }

  void _ensureWaveform(int barCount) {
    if (barCount <= 0) {
      _barHeights = const [];
      _lastBarCount = 0;
      return;
    }
    if (barCount == _lastBarCount) return;

    const minHeight = 5.0;
    const maxHeight = 22.0;
    final random = math.Random(widget.audioUrl.hashCode ^ barCount);

    _barHeights = List<double>.generate(
      barCount,
      (_) => minHeight + random.nextDouble() * (maxHeight - minHeight),
    );
    _lastBarCount = barCount;
  }

  Future<void> _togglePlayPause() async {
    final url = widget.audioUrl.trim();
    if (url.isEmpty) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        return;
      }

      final atEnd = _duration > Duration.zero &&
          _position >= _duration - const Duration(milliseconds: 120);

      if (!_startedOnce || atEnd) {
        await _audioPlayer.play(UrlSource(url));
        _startedOnce = true;
      } else {
        await _audioPlayer.resume();
      }
    } catch (_) {
      // Fail silently to keep chat UI stabl
    }
  }

  Future<void> _seek(double value) async {
    if (_duration == Duration.zero) return;

    final maxMs = _duration.inMilliseconds;
    final targetMs = value.round().clamp(0, maxMs);

    try {
      await _audioPlayer.seek(Duration(milliseconds: targetMs));
    } catch (_) {
      // Ignore seek erro
    }
  }

  @override
  void dispose() {
    _playerStateSub.cancel();
    _durationSub.cancel();
    _positionSub.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = widget.height ?? 40.0;

    return SizedBox(
      width: widget.width,
      height: resolvedHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double totalWidth;
          if (widget.width != null) {
            totalWidth = widget.width!;
          } else if (constraints.maxWidth.isFinite) {
            totalWidth = constraints.maxWidth;
          } else {
            totalWidth = MediaQuery.sizeOf(context).width * 0.65;
          }

          const buttonSize = 32.0;
          const gap = 10.0;
          final waveformWidth = math.max(0.0, totalWidth - buttonSize - gap);

          final rawCount = (waveformWidth / 6.0).floor();
          final barCount = rawCount.clamp(12, 140);
          _ensureWaveform(barCount);

          final maxMs =
              _duration.inMilliseconds > 0 ? _duration.inMilliseconds : 1;
          final sliderMax = maxMs.toDouble();
          final sliderValue =
              _position.inMilliseconds.clamp(0, maxMs).toDouble();

          final progress = _duration.inMilliseconds > 0
              ? (_position.inMilliseconds / _duration.inMilliseconds)
                  .clamp(0.0, 1.0)
              : 0.0;

          return Row(
            children: [
              Container(
                width: buttonSize,
                height: buttonSize,
                margin: const EdgeInsets.only(right: gap),
                decoration: const BoxDecoration(
                  color: _activeColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  splashRadius: 16,
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: WaveformPainter(
                          progress: progress,
                          barHeights: _barHeights,
                          activeColor: _activeColor,
                          inactiveColor: _inactiveColor,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackShape: RectangularSliderTrackShape(),
                          trackHeight: 0.0,
                          thumbShape: SliderComponentShape.noThumb,
                          overlayShape: SliderComponentShape.noOverlay,
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                        ),
                        child: Slider(
                          min: 0.0,
                          max: sliderMax,
                          value: sliderValue,
                          onChanged: _duration > Duration.zero ? _seek : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  const WaveformPainter({
    required this.progress,
    required this.barHeights,
    required this.activeColor,
    required this.inactiveColor,
  });

  final double progress; // 0..1
  final List<double> barHeights;
  final Color activeColor;
  final Color inactiveColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (barHeights.isEmpty || size.width <= 0 || size.height <= 0) return;

    const barWidth = 2.0;
    const spacing = 4.0;
    final activeX = size.width * progress.clamp(0.0, 1.0);

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.fill;

    double x = 0.0;
    for (int i = 0; i < barHeights.length; i++) {
      if (x > size.width) break;

      final h = barHeights[i].clamp(4.0, size.height);
      final y = (size.height - h) / 2;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, h),
        const Radius.circular(2),
      );

      canvas.drawRRect(
        rrect,
        (x + barWidth) <= activeX ? activePaint : inactivePaint,
      );

      x += barWidth + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        !listEquals(oldDelegate.barHeights, barHeights);
  }
}
