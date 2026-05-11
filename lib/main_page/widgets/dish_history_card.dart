import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/services/nutrition_summary.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DishHistoryCard extends StatelessWidget {
  const DishHistoryCard({
    super.key,
    required this.record,
    required this.useOunces,
  });

  final AddedDishHistoryRecord record;
  final bool useOunces;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () {
        context.pushNamed(
          DishInfoWidget.routeName,
          queryParameters: {
            'dish': serializeParam(
              record.reference,
              ParamType.DocumentReference,
            ),
          }.withoutNulls,
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: useOunces ? 104.0 : 88.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: valueOrDefault<String>(
                      record.image,
                      'https://firebasestorage.googleapis.com/v0/b/eat-out-a-i-h2yogm.firebasestorage.app/o/AppImages%2FZaglushkaDish.png?alt=media&token=removed',
                    ),
                    memCacheWidth: 160,
                    memCacheHeight: 220,
                    maxWidthDiskCache: 320,
                    maxHeightDiskCache: 440,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    width: 80.0,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      width: 80.0,
                      color: const Color(0xFFE5E7EB),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xFF8E8E93),
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        12.0, 2.0, 0.0, 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.dishName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 14.0),
                        Row(
                          children: [
                            Text(
                              NutritionSummary.formatGrams(
                                record.dishWeight,
                                useOunces: useOunces,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Text(
                              '${record.kcal} kcal',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ].divide(const SizedBox(width: 12.0)),
                        ),
                        const SizedBox(height: 4.0),
                        Wrap(
                          spacing: 12.0,
                          runSpacing: 4.0,
                          children: [
                            MacroPill(
                              color: const Color(0xFF49928C),
                              value: NutritionSummary.formatGrams(
                                record.proteins,
                                useOunces: useOunces,
                              ),
                            ),
                            MacroPill(
                              color: const Color(0xFFF19656),
                              value: NutritionSummary.formatGrams(
                                record.fats,
                                useOunces: useOunces,
                              ),
                            ),
                            MacroPill(
                              color: const Color(0xFF9F4284),
                              value: NutritionSummary.formatGrams(
                                record.carbs,
                                useOunces: useOunces,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MacroPill extends StatelessWidget {
  const MacroPill({
    super.key,
    required this.color,
    required this.value,
  });

  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4.0),
        Text(
          value,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro',
                fontSize: 16.0,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }
}
