import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/profile/universal_picker/universal_picker_widget.dart';
import '/services/calorie_goal_service.dart';
import 'package:flutter/material.dart';
import '/custom_code/actions/index.dart' as actions;
import 'kcal_bottom_sheet_model.dart';
export 'kcal_bottom_sheet_model.dart';

class KcalBottomSheetWidget extends StatefulWidget {
  const KcalBottomSheetWidget({super.key});

  @override
  State<KcalBottomSheetWidget> createState() => _KcalBottomSheetWidgetState();
}

class _KcalBottomSheetWidgetState extends State<KcalBottomSheetWidget> {
  late KcalBottomSheetModel _model;
  bool _hasLoadedUserValues = false;
  bool _isSaving = false;

  CalorieGoalResult get _calculation => CalorieGoalService.calculate(
        heightCm: _model.height,
        weightKg: _model.weight,
        age: _model.age,
        gender: _model.gender,
        activityLevel: _model.activityLevel,
        userGoal: _model.userGoal,
      );

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KcalBottomSheetModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Future<void> _pickHeight() async {
    final value = await actions.heightPicker(
      context,
      true,
      _model.height,
      'English',
    );
    if (value != null) {
      safeSetState(() => _model.height = value);
    }
  }

  Future<void> _pickWeight() async {
    final value = await actions.weightPicker(
      context,
      true,
      _model.weight,
      'English',
    );
    if (value != null) {
      safeSetState(() => _model.weight = value);
    }
  }

  Future<void> _pickAge() async {
    final value = await actions.agePicker(
      context,
      _model.age,
      'English',
    );
    if (value != null) {
      safeSetState(() => _model.age = value);
    }
  }

  Future<void> _pickString({
    required List<String> options,
    required String? initialValue,
    required ValueChanged<String> onSelected,
  }) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.28,
              child: UniversalPickerWidget(
                options: options,
                initialValue: initialValue?.isNotEmpty == true
                    ? initialValue!
                    : options.first,
                onSelected: (value) async {
                  if (value == null) return;
                  onSelected(value);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _loadUserValues(UsersRecord? user) {
    if (_hasLoadedUserValues || user == null) return;

    _model.height ??= user.height > 0 ? user.height : null;
    _model.weight ??= user.weight > 0 ? user.weight : null;
    _model.age ??= user.age > 0 ? user.age : null;
    _model.gender ??= user.gender.isNotEmpty ? user.gender : null;
    _model.activityLevel ??=
        user.activityLevel.isNotEmpty ? user.activityLevel : null;
    _model.userGoal ??= user.userGoal.isNotEmpty ? user.userGoal : null;
    _hasLoadedUserValues = true;
  }

  Future<void> _ensureUserValuesLoaded() async {
    if (_hasLoadedUserValues) return;

    final user = currentUserDocument;
    if (user != null) {
      _loadUserValues(user);
      return;
    }

    final userReference = currentUserReference;
    if (userReference == null) return;

    try {
      final loadedUser = await UsersRecord.getDocumentOnce(userReference);
      currentUserDocument = loadedUser;
      if (mounted) {
        safeSetState(() => _loadUserValues(loadedUser));
      }
    } catch (_) {
      // Save will show a user-facing error if required fields are still absent.
    }
  }

  String _missingFieldsMessage(List<String> fields) {
    const labels = <String, String>{
      'heightCm': 'Height',
      'weightKg': 'Weight',
      'age': 'Age',
      'gender': 'Gender',
      'activityLevel': 'Activity level',
      'userGoal': 'Goal',
    };

    return fields.map((field) => labels[field] ?? field).join(', ');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  Future<void> _saveGoals() async {
    if (_isSaving) return;

    await _ensureUserValuesLoaded();

    final result = _calculation;
    if (!result.isComplete) {
      _showError(
        'Please fill in: ${_missingFieldsMessage(result.missingFields)}.',
      );
      return;
    }

    final userReference = currentUserReference;
    if (userReference == null) {
      _showError('Unable to save. Please sign in again.');
      return;
    }

    safeSetState(() => _isSaving = true);
    try {
      await userReference.update(
        createUsersRecordData(
          height: _model.height,
          weight: _model.weight,
          age: _model.age,
          gender: _model.gender,
          activityLevel: _model.activityLevel,
          userGoal: _model.userGoal,
          kcalGoal: result.kcalGoal,
          proteinsGoal: result.proteinsGoal,
          fatsGoal: result.fatsGoal,
          carbsGoal: result.carbsGoal,
        ),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        _showError('Could not save calorie goals. Please try again.');
      }
    } finally {
      if (mounted) {
        safeSetState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthUserStreamWidget(
      builder: (context) {
        _loadUserValues(currentUserDocument);
        final result = _calculation;

        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              border: Border.all(
                color: FlutterFlowTheme.of(context).primary,
                width: 2.0,
              ),
            ),
            child: Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Container(
                constraints: BoxConstraints(maxWidth: 600.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Calorie goals',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'SF Pro',
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 45.0,
                            icon: Icon(
                              Icons.close,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 16.0, 12.0, 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _GoalPreview(result: result),
                            _PickerRow(
                              title: 'Height',
                              value: _model.height == null
                                  ? 'Not set'
                                  : '${_model.height!.toStringAsFixed(1)} cm',
                              isEmpty: _model.height == null,
                              onTap: _pickHeight,
                            ),
                            _PickerRow(
                              title: 'Weight',
                              value: _model.weight == null
                                  ? 'Not set'
                                  : '${_model.weight!.toStringAsFixed(1)} kg',
                              isEmpty: _model.weight == null,
                              onTap: _pickWeight,
                            ),
                            _PickerRow(
                              title: 'Age',
                              value: _model.age == null
                                  ? 'Not set'
                                  : '${_model.age} years',
                              isEmpty: _model.age == null,
                              onTap: _pickAge,
                            ),
                            _PickerRow(
                              title: 'Gender',
                              value: _model.gender ?? 'Not set',
                              isEmpty: _model.gender == null,
                              onTap: () => _pickString(
                                options: FFAppConstants.gender,
                                initialValue: _model.gender,
                                onSelected: (value) {
                                  safeSetState(() => _model.gender = value);
                                },
                              ),
                            ),
                            _PickerRow(
                              title: 'Activity level',
                              value: _model.activityLevel ?? 'Not set',
                              isEmpty: _model.activityLevel == null,
                              onTap: () => _pickString(
                                options: FFAppConstants.ActivityLevel,
                                initialValue: _model.activityLevel,
                                onSelected: (value) {
                                  safeSetState(
                                      () => _model.activityLevel = value);
                                },
                              ),
                            ),
                            _PickerRow(
                              title: 'Goal',
                              value: _model.userGoal ?? 'Not set',
                              isEmpty: _model.userGoal == null,
                              onTap: () => _pickString(
                                options: FFAppConstants.UserGoal,
                                initialValue: _model.userGoal,
                                onSelected: (value) {
                                  safeSetState(() => _model.userGoal = value);
                                },
                              ),
                            ),
                          ].divide(SizedBox(height: 10.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 20.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: _isSaving
                            ? null
                            : () async {
                                await _saveGoals();
                              },
                        child: Container(
                          width: double.infinity,
                          height: 52.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Text(
                            _isSaving ? 'Saving...' : 'Save and apply goals',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'SF Pro',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GoalPreview extends StatelessWidget {
  const _GoalPreview({required this.result});

  final CalorieGoalResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).mainPageBG,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Daily target',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'SF Pro',
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                Text(
                  result.isComplete ? '${result.kcalGoal} kcal' : '-',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'SF Pro',
                        fontSize: 22.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            Divider(
              height: 24.0,
              thickness: 1.0,
              color: FlutterFlowTheme.of(context).alternate,
            ),
            _MacroLine(label: 'Protein', value: result.proteinsGoal),
            _MacroLine(label: 'Fats', value: result.fatsGoal),
            _MacroLine(label: 'Carbs', value: result.carbsGoal),
          ].divide(SizedBox(height: 8.0)),
        ),
      ),
    );
  }
}

class _MacroLine extends StatelessWidget {
  const _MacroLine({
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro',
                fontSize: 15.0,
                letterSpacing: 0.0,
              ),
        ),
        Text(
          value == 0 ? '-' : '$value g',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'SF Pro',
                fontSize: 15.0,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.title,
    required this.value,
    required this.isEmpty,
    required this.onTap,
  });

  final String title;
  final String value;
  final bool isEmpty;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).mainPageBG,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 15.0, 12.0, 15.0),
          child: Row(
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'SF Pro',
                      color: FlutterFlowTheme.of(context).textfieldsText,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'SF Pro',
                          color: isEmpty
                              ? Color(0xFF9B9A9D)
                              : FlutterFlowTheme.of(context).primaryText,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                child: Icon(
                  Icons.unfold_more,
                  color: FlutterFlowTheme.of(context).listPicker,
                  size: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
