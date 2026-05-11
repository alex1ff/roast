import '/backend/schema/structs/dish_page_vitamins_data_struct.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DishInfoThumbnail extends StatelessWidget {
  const DishInfoThumbnail({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFFF2F2F7),
            width: 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: CachedNetworkImage(
            fadeInDuration: const Duration(milliseconds: 0),
            fadeOutDuration: const Duration(milliseconds: 0),
            imageUrl: imageUrl,
            memCacheWidth: 160,
            memCacheHeight: 220,
            maxWidthDiskCache: 320,
            maxHeightDiskCache: 440,
            width: 80.0,
            height: 110.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class DishInfoNutritionMeta extends StatelessWidget {
  const DishInfoNutritionMeta({
    super.key,
    required this.proteins,
    required this.fats,
    required this.carbs,
    required this.badge,
    required this.impact,
    required this.calorieShare,
  });

  final String proteins;
  final String fats;
  final String carbs;
  final String badge;
  final String impact;
  final String calorieShare;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MacroValue(
              label: 'Protein',
              value: proteins,
              color: const Color(0xFF80BFB4),
            ),
            _MacroValue(
              label: 'Fat',
              value: fats,
              color: const Color(0xFFF19656),
            ),
          ].divide(const SizedBox(width: 10.0)),
        ),
        _MacroValue(
          label: 'Carbs',
          value: carbs,
          color: const Color(0xFF9F4284),
        ),
        Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          clipBehavior: Clip.none,
          children: [
            _MetaChip(
              text: badge,
              color: FlutterFlowTheme.of(context).error,
            ),
            _MetaChip(
              text: impact,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            _MetaChip(
              text: calorieShare,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ],
        ),
      ],
    );
  }
}

class DishInfoTipsSection extends StatelessWidget {
  const DishInfoTipsSection({
    super.key,
    required this.tips,
  });

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return DishInfoSectionCard(
      title: 'Damage Control',
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _InfoTextBox(text: valueOrDefault<String>(tips.firstOrNull, '-')),
          _InfoTextBox(
              text: valueOrDefault<String>(tips.elementAtOrNull(1), '-')),
          _InfoTextBox(
            text: valueOrDefault<String>(tips.elementAtOrNull(2), '-'),
            borderRadius: 16.0,
          ),
        ].divide(const SizedBox(height: 6.0)),
      ),
    );
  }
}

class DishInfoIngredientsSection extends StatelessWidget {
  const DishInfoIngredientsSection({
    super.key,
    required this.ingredients,
  });

  final List<String> ingredients;

  @override
  Widget build(BuildContext context) {
    return DishInfoSectionCard(
      title: 'AI Spotted Ingredients',
      child: Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        clipBehavior: Clip.none,
        children: ingredients.map((ingredient) {
          return _IngredientChip(text: ingredient);
        }).toList(),
      ),
    );
  }
}

class DishInfoVitaminsSection extends StatelessWidget {
  const DishInfoVitaminsSection({
    super.key,
    required this.vitamins,
  });

  final List<DishPageVitaminsDataStruct> vitamins;

  @override
  Widget build(BuildContext context) {
    return DishInfoSectionCard(
      title: 'Buffs',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: vitamins
            .map((vitamin) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F2F7),
                      shape: BoxShape.circle,
                    ),
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Text(
                      vitamin.vitamin,
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'SF Pro',
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 0.0, 0.0, 0.0),
                      child: Text(
                        vitamin.description,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'SF Pro',
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              lineHeight: 1.5,
                            ),
                      ),
                    ),
                  ),
                ],
              );
            })
            .toList()
            .divide(const SizedBox(height: 6.0)),
      ),
    );
  }
}

class DishInfoSectionCard extends StatelessWidget {
  const DishInfoSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro',
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    lineHeight: 1.5,
                  ),
            ),
            child,
          ].divide(const SizedBox(height: 16.0)),
        ),
      ),
    );
  }
}

class _MacroValue extends StatelessWidget {
  const _MacroValue({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro',
                color: color,
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.normal,
              ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
          child: Container(
            width: 4.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
          child: Text(
            '$value g',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'SF Pro',
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
            child: Text(
              text,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'SF Pro',
                    color: color,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTextBox extends StatelessWidget {
  const _InfoTextBox({
    required this.text,
    this.borderRadius = 10.0,
  });

  final String text;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro',
                fontSize: 16.0,
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro',
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.normal,
              ),
        ),
      ),
    );
  }
}
