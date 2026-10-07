# Disposable email domains

Source: https://github.com/disposable-email-domains/disposable-email-domains
Revision: 6fcca80a3fd4c4a5f7c364788f3b4812a8325754
Imported: 2026-10-07
License: CC0 1.0 (see DISPOSABLE_EMAIL_LICENSE.txt).

The checked-in snapshot contains 9213 domains. Signup checks the
exact domain and its parent domains. The list is loaded locally in the Firebase
function; registration does not fetch GitHub or send mailbox addresses to a
validation provider.

To refresh it, import disposable_email_blocklist.conf from a reviewed upstream
revision, retain the license and update this revision. Run the email-domain
regression tests and deploy only functions:functions:validateEmailDomain.

Permanent Proton Mail domains and Apple's private relay are explicitly allowed.
The list detects known disposable providers. It does not prove that an individual
mailbox exists and is not a substitute for email verification.
