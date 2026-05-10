import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'poli_model.dart';
export 'poli_model.dart';

class PoliWidget extends StatefulWidget {
  const PoliWidget({super.key});

  static String routeName = 'poli';
  static String routePath = '/poli';

  @override
  State<PoliWidget> createState() => _PoliWidgetState();
}

class _PoliWidgetState extends State<PoliWidget> {
  late PoliModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PoliModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF2F2F7),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 600.0,
                      ),
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MarkdownBody(
                                data:
                                    '''# Privacy Policy – Roast NutriTracker\n\n**Effective Date:** 21 April 2026\n\nRoast NutriTracker (“we,” “us,” “our,” or “the App”) respects your privacy. This Privacy Policy explains how we collect, use, share, and protect information when you use the App.\n\nRoast NutriTracker provides nutrition estimates and humorous entertainment content. Nutrition results are approximate and should not be treated as medical advice.\n\n## 1. Information We Collect\n\nWe may collect or process the following information when you use the App:\n\n- **Images You Provide:** Photos you upload or capture in the App, including food photos, person photos, object photos, or scene photos, for nutrition analysis and entertainment-based roast generation.\n- **Text You Provide:** Dish names, ingredients, restaurant names, goals, activity level, calorie goals, language preferences, roast level, persona selection, and other text entered into the App.\n- **Nutrition Inputs:** Optional information such as user goal, activity level, calorie target, dish weight, and ingredients used to generate nutrition estimates.\n- **Audio or Voice Input:** If voice features are available and you choose to use them, audio may be processed to generate speech, transcription, or spoken responses.\n- **Usage and Diagnostics Data:** Anonymous or technical information such as app performance, feature usage, crash logs, device type, operating system version, and error reports.\n- **Contact Information:** If you contact us directly, we may receive your email address and any information you choose to include in your message.\n\nThe App does not require you to create an account.\n\n## 2. How We Use Your Information\n\nWe use information only to:\n\n- Provide nutrition estimates and entertainment-based roast responses.\n- Process images, text, and optional voice input through AI services.\n- Improve app reliability, performance, and user experience.\n- Diagnose bugs, crashes, and technical issues.\n- Respond to support requests.\n- Comply with legal, platform, safety, and security requirements.\n\nWe do **not** use your data for third-party advertising or tracking across other apps or websites.\n\n## 3. Third-Party Services\n\nThe App may rely on trusted third-party services to deliver its features:\n\n- **AI service providers** – for AI-generated text, image understanding, nutrition estimates, and entertainment responses.\n- **ElevenLabs** – if voice features are enabled, for speech generation, voice processing, or related audio functionality.\n- **Analytics or Crash Reporting Providers** – if enabled, for app performance monitoring and diagnostics.\n\nWhen you submit images, text, or audio, that content may be transmitted to these providers for processing. Their processing is governed by their own privacy policies and data retention practices.\n\nWe encourage you to review their policies:\n\n- OpenAI: https://openai.com/policies/privacy-policy\n- ElevenLabs: https://elevenlabs.io/privacy-policy\n\n## 4. Data Retention\n\nWe do not intentionally retain submitted images, text, or voice inputs after processing. However, limited data may be temporarily stored or processed where necessary for security, debugging, legal compliance, support, or abuse prevention.\n\nThird-party AI providers may retain limited data according to their own policies, safety requirements, and configured retention settings.\n\nDiagnostic logs, crash reports, and technical data may be retained for a limited period to maintain and improve the App.\n\n## 5. Data We Do Not Sell\n\nWe do **not**:\n\n- Sell, rent, or trade your personal data.\n- Use your data for personalized advertising.\n- Track you across other apps or websites for advertising purposes.\n- Require account registration to use the App.\n\n## 6. Health and Nutrition Disclaimer\n\nRoast NutriTracker provides approximate nutrition estimates for informational and entertainment purposes only.\n\nThe App is **not a medical device** and does not diagnose, treat, cure, or prevent any disease or medical condition.\n\nNutrition estimates may be inaccurate due to photo quality, portion size uncertainty, hidden ingredients, restaurant preparation methods, sauces, oils, or incomplete user input.\n\nAlways consult a qualified healthcare professional, dietitian, or nutrition specialist before making medical, dietary, weight-loss, or health-related decisions.\n\n## 7. Entertainment and Parody Disclaimer\n\nRoast NutriTracker provides lighthearted, humorous, and satirical commentary.\n\n- All roasts are fictional and for entertainment purposes only.\n- The App may use fictional, parody, or stylistic personas. It does not represent or claim endorsement from any real person, celebrity, brand, or fictional character.\n- Any resemblance to real individuals, characters, brands, or trademarks is coincidental, transformative, humorous, or satirical.\n- Users should not rely on roast content as factual judgment, medical advice, or personal assessment.\n- The App does not create statements of fact about any individual.\n\n## 8. User Content and Consent\n\nBy submitting images, text, or audio to the App, you confirm that:\n\n- You have the right to submit the content.\n- You understand that the content may be processed by third-party AI services to generate results.\n- You will not upload content that violates another person’s privacy, rights, or applicable law.\n- You will not upload images of other people without appropriate permission where required.\n- You are solely responsible for any content involving identifiable individuals, including obtaining any necessary consent and for any consequences arising from such use.\n\nIf the App requests access to your camera, microphone, or photo library, access is used only to provide the relevant App feature.\n\n## 9. Children’s Privacy\n\nThe App is not intended for children under 13 years old. We do not knowingly allow the App to be used to generate content involving minors in a harmful or inappropriate way.\n\nWe do not knowingly collect personal information from children under 13. If you believe a child has provided personal information through the App, please contact us at [**nutritrackerrr@gmail.com**](mailto:nutritrackerrr@gmail.com), and we will take appropriate steps to delete it.\n\nUsers should not upload photos of children without permission from a parent or legal guardian.\n\n## 10. Data Security\n\nWe use reasonable technical and organizational measures to protect information from unauthorized access, alteration, loss, misuse, or disclosure.\n\nHowever, no method of transmission or storage is completely secure. We cannot guarantee absolute security.\n\n## 11. Your Rights\n\nDepending on your location, you may have the right to:\n\n- Request access to your personal data.\n- Request deletion of your personal data.\n- Request correction of inaccurate information.\n- Withdraw consent where processing is based on consent.\n- Object to or restrict certain processing.\n- Request information about how your data is shared.\n- Some rights may depend on your jurisdiction.\n\nTo exercise these rights, contact us at:\n\n[**nutritrackerrr@gmail.com**](mailto:nutritrackerrr@gmail.com)\n\nWe will respond in accordance with applicable data-protection laws.\n\n## 12. International Data Processing\n\nYour information may be processed in countries other than your country of residence, including countries where our third-party service providers operate.\n\nBy using the App, you understand that your information may be processed outside your jurisdiction, subject to applicable law and provider safeguards.\n\n## 13. Updates to This Policy\n\nWe may update this Privacy Policy from time to time to reflect changes in the App, legal requirements, platform requirements, or data practices.\n\nThe latest version will be available in the App and identified by its effective date.\n\n## 14. Contact Us\n\nIf you have any questions, concerns, or requests related to this Privacy Policy, contact us at:\n\n[**nutritrackerrr@gmail.com**](mailto:nutritrackerrr@gmail.com)\n\n## 15. Applicable Law\n\nThis Privacy Policy will be interpreted and applied in accordance with the applicable laws of your jurisdiction.''',
                                selectable: true,
                                onTapLink: (_, url, __) => launchURL(url!),
                              ),
                            ]
                                .addToStart(SizedBox(height: 125.0))
                                .addToEnd(SizedBox(height: 100.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).secondaryBackground,
                          Color(0xF2F2F2F7),
                          Color(0x00F2F2F7)
                        ],
                        stops: [0.0, 0.8, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          12.0, 55.0, 12.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 45.0,
                            height: 45.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 7.0,
                                  color: Color(0x0D2C2C2C),
                                  offset: Offset(
                                    0.0,
                                    2.0,
                                  ),
                                )
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: FlutterFlowIconButton(
                              borderRadius: 70.0,
                              buttonSize: 45.0,
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 14.0,
                              ),
                              onPressed: () async {
                                context.safePop();
                              },
                            ),
                          ),
                          Text(
                            'Privacy Policy',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'SF Pro',
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Container(
                            width: 45.0,
                            height: 45.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
