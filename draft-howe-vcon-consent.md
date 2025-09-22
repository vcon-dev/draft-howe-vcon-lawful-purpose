---
title: "vCon Consent"
abbrev: "vCon Consent"
category: std
docname: draft-howe-vcon-consent-00
ipr: trust200902
area: "Applications and Real-Time"
workgroup: "vCon"
keyword: Internet-Draft
venue:
  group: "vCon"
  type: "Working Group"
  mail: "vcon@ietf.org"
  arch: "https://mailarchive.ietf.org/arch/browse/vcon/"
  github: "vcon-dev/vcon"
  latest: "https://vcon-dev.github.io/draft-howe-vcon-consent/draft-howe-vcon-consent-latest.html"

stand_alone: yes
smart_quotes: no
pi: [toc, sortrefs, symrefs]

author:
 -
    name: Thomas McCarthy-Howe
    organization: Strolid
    email: thomas@strolid.com

normative:
  RFC2119:
  RFC8174:
  RFC3339:
    target: https://www.rfc-editor.org/rfc/rfc3339.html
    title: "Date and Time on the Internet: Timestamps"
    author:
      name: G. Klyne
      ins: G. Klyne
    date: July 2002

  I-D.draft-ietf-vcon-core-00:
    target: I-D.draft-ietf-vcon-core-00
    title: "Virtualized Conversation (vCon) Container"
    author:
      -
        ins: D. Petrie
        name: Daniel Petrie
        org: SIPez LLC
    date: March 2025
    seriesinfo:
      Internet-Draft: draft-ietf-vcon-core-00

  I-D.draft-ietf-scitt-scrapi-05:
    target: I-D.draft-ietf-scitt-scrapi-05
    title: "SCITT Receipt API"
    author:
      -
        ins: H. Birkholz
        name: Henk Birkholz
        org: Fraunhofer SIT
    date: February 2025
    seriesinfo:
      Internet-Draft: draft-ietf-scitt-scrapi-05

  RFC8949:
    target: https://www.rfc-editor.org/rfc/rfc8949.html
    title: "Concise Binary Object Representation (CBOR)"
    author:
      name: C. Bormann
      ins: C. Bormann
    date: December 2020

informative:
  I-D.draft-ietf-vcon-overview:
    target: I-D.draft-ietf-vcon-overview-00
    title: "The vCon - Conversation Data Container - Overview"
    author:
      -
        name: Thomas McCarthy-Howe
        org: Strolid
    date: July 2025
    seriesinfo:
      Internet-Draft: draft-ietf-vcon-overview-00

  GDPR:
    target: https://gdpr.eu/
    title: "General Data Protection Regulation"
    author:
      org: European Union
    date: 2018

  CCPA:
    target: https://oag.ca.gov/privacy/ccpa
    title: "California Consumer Privacy Act"
    author:
      org: State of California
    date: 2018

  HIPAA:
    target: https://www.hhs.gov/hipaa/index.html
    title: "Health Insurance Portability and Accountability Act"
    author:
      org: U.S. Department of Health and Human Services
    date: 1996

  NIST-PRIVACY:
    target: https://www.nist.gov/privacy-framework
    title: "NIST Privacy Framework"
    author:
      org: National Institute of Standards and Technology
    date: 2020

  COSE-ALG:
    target: https://www.iana.org/assignments/cose/cose.xhtml
    title: "COSE Algorithms"
    author:
      org: IANA
    date: n.d.

--- abstract

This document defines a consent extension for Virtualized Conversations (vCon) that provides standardized mechanisms for recording, verifying, and managing consent information within conversation containers. The consent extension addresses privacy compliance challenges through structured attachment metadata including consenting parties, temporal validity periods, and cryptographic proof mechanisms.

The extension is designed as a Compatible vCon extension that introduces consent management capabilities without altering existing vCon semantics. It defines a "consent" attachment type with structured consent records, temporal validity controls, and integration with SCITT transparency services for cryptographic verification.

Key features include automated consent detection during conversation processing, auditable consent records with cryptographic proofs, granular purpose-based permissions, support for consent revocation, and integration with privacy regulations including GDPR, CCPA, and HIPAA.

--- middle

# Introduction

 Conversations originating from all modes (voice, video, email, fax and messaging), contain sensitive information that requires proper consent management to comply with privacy regulations and ethical standards. This document defines a consent extension for Virtualized Conversations (vCon) that enables automated consent detection, structured consent recording, and cryptographic proof mechanisms.

A vCon (Virtualized Conversation) is a standardized container format for storing conversation data, including metadata, participants, and conversation content, as defined in [I-D.draft-ietf-vcon-core-00]. The vCon specification supports extensible attachments that can carry additional structured data related to the conversation.

This consent extension provides a Compatible vCon extension (as defined in Section 2.5 of [I-D.draft-ietf-vcon-core-00]) that introduces consent management capabilities through a standardized "consent" attachment type. The extension captures essential consent metadata including:

- Consenting party identification and dialog segment references
- Temporal validity periods with configurable expiration
- Granular purpose-based consent permissions
- Cryptographic proof mechanisms and external verification
- Integration with SCITT transparency services for audit trails

The consent extension addresses key privacy and compliance challenges while maintaining compatibility with existing vCon implementations. Implementations that do not recognize the consent extension can safely ignore consent attachments while maintaining valid processing of other vCon content.

# Conventions and Definitions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 [RFC2119] [RFC8174] when, and only when, they appear in all capitals, as shown here.

## Core Terms

**Consent**: Any freely given, specific, informed, and unambiguous indication of the data subject's wishes by which they, by a statement or by a clear affirmative action, signify agreement to the processing of personal data relating to them [GDPR].

**Data Subject**: The identified or identifiable natural person to whom personal data relates [GDPR].

**Consent Attachment**: A vCon attachment with type "consent" that contains structured consent information for conversation participants.

**Consent Ledger**: A SCITT Transparency Service that maintains authoritative consent state and provides cryptographic receipts for consent operations.

**Compatible Extension**: A vCon extension that introduces additional data without altering the meaning or structure of existing elements, as defined in [I-D.draft-ietf-vcon-core-00].

**Lawful Purpose**: A legal basis for processing personal data, as defined by applicable regulations such as GDPR. Processing is only lawful if it is based on one of the specified lawful purposes.

# Lawful Purpose and Consent

While this document focuses on consent, it is important to understand that consent is only one of several lawful bases for processing personal data. Under regulations like the GDPR, there are six lawful bases for processing personal data. Consent is one of them, but not the only one. Understanding the full scope of lawful purposes helps to correctly position consent within a broader compliance framework.

The six lawful bases for processing under GDPR are:

1.  **Consent**: The data subject has given clear, unambiguous consent for their personal data to be processed for a specific purpose. This is the basis detailed in this document.

2.  **Contract**: The processing is necessary for a contract that the data subject has with the organization, or because they have asked the organization to take specific steps before entering into a contract. For example, processing a customer's address to deliver a purchased product.

3.  **Legal Obligation**: The processing is necessary for the organization to comply with the law (not including contractual obligations). For example, a financial institution may be legally required to report certain transactions to prevent fraud.

4.  **Vital Interests**: The processing is necessary to protect someone's life. For example, sharing a patient's medical history with emergency services.

5.  **Public Task**: The processing is necessary for the organization to perform a task in the public interest or for its official functions, and the task or function has a clear basis in law. For example, a local authority processing data to provide public services.

6.  **Legitimate Interests**: The processing is necessary for the organization's legitimate interests or the legitimate interests of a third party, unless there is a good reason to protect the individual's personal data which overrides those legitimate interests. For example, a business using customer data for marketing analysis to improve its services, provided it does not infringe on the customer's privacy rights.

This consent extension for vCon is primarily concerned with the "Consent" basis, providing a standardized way to record and verify it. However, a vCon could be processed under other lawful bases, and the presence or absence of a consent attachment does not, by itself, determine the overall lawfulness of processing the vCon's data.

# vCon Consent Extension Definition

## Extension Classification

The consent extension is a **Compatible Extension** as defined in Section 2.5 of [I-D.draft-ietf-vcon-core-00]. This extension:

- Introduces additional consent metadata without altering existing vCon semantics
- Can be safely ignored by implementations that don't support consent processing
- Does not require listing in the `must_support` parameter
- Maintains backward compatibility with existing vCon implementations

## Extension Registration

This document defines the "consent" extension token for registration in the vCon Extensions Names Registry:

- **Extension Name**: consent
- **Extension Description**: Consent management for voice conversation participants with cryptographic proof mechanisms and regulatory compliance support
- **Change Controller**: IESG
- **Specification Document**: This document

## Extension Usage

vCon instances that include consent attachments SHOULD include "consent" in the `extensions` array:

```json
{
  "uuid": "01234567-89ab-cdef-0123-456789abcdef",
  "extensions": ["consent"],
  "created_at": "2025-01-02T12:00:00Z",
  "parties": [...],
  "dialog": [...],
  "attachments": [
    {
      "type": "consent",
      "start": "2025-01-02T12:15:30Z",
      "party": 0,
      "dialog": 0,
      "encoding": "json",
      "body": {
        // Consent data structure defined below
      }
    }
  ]
}
```

# Consent Attachment Structure

## Attachment Container

Consent information MUST be included as vCon attachments using the standard attachment object structure defined in Section 4.4 of [I-D.draft-ietf-vcon-core-00].

The consent attachment MUST include:

- **type**: MUST be set to "consent"
- **encoding**: MUST be set to "json" for structured consent data
- **body**: MUST contain the consent data structure as defined below

The consent attachment SHOULD include:

- **start**: ISO 8601 timestamp when consent was recorded
- **party**: Index of the consenting party in the vCon parties array
- **dialog**: Index of the associated dialog in the vCon dialog array

## Consent Body Structure

The `body` field of the consent attachment MUST contain a JSON object with the following structure:

### Required Fields

- **expiration**: ISO 8601 timestamp indicating when consent expires, or `null` for indefinite consent
- **consent_grants**: Array of consent grant objects specifying permissions

### Optional Fields

- **terms_of_service**: URL reference to applicable terms of service document
- **status_interval**: Duration string for consent revalidation intervals (e.g., "30d")
- **consent_ledger**: URL to external SCITT consent ledger for transparency
- **proof_mechanisms**: Array of proof objects supporting the consent
- **metadata**: Additional implementation-specific consent metadata

### Consent Grant Objects

Each object in the `consent_grants` array MUST contain:

- **purpose**: String identifying the processing purpose (e.g., "recording", "transcription", "analysis")
- **granted**: Boolean indicating whether consent is granted (true) or denied (false)
- **granted_at**: ISO 8601 timestamp when this specific consent was granted
- **conditions**: Optional array of strings describing consent conditions or restrictions

### Proof Mechanism Objects

Each object in the `proof_mechanisms` array MUST contain:

- **proof_type**: String identifying the proof mechanism type
- **timestamp**: ISO 8601 timestamp when proof was created
- **proof_data**: Object containing proof-type-specific data

Supported proof types include:

- **verbal_confirmation**: Consent given verbally within the conversation
- **signed_document**: External signed consent form or agreement
- **cryptographic_signature**: Digital signature using COSE standards
- **external_system**: Consent recorded in external system with API verification

## Example Consent Attachment

```json
{
  "type": "consent",
  "start": "2025-01-02T12:15:30Z",
  "party": 0,
  "dialog": 0,
  "encoding": "json",
  "body": {
    "expiration": "2026-01-02T12:00:00Z",
    "consent_grants": [
      {
        "purpose": "recording",
        "granted": true,
        "granted_at": "2025-01-02T12:15:30Z"
      },
      {
        "purpose": "transcription",
        "granted": true,
        "granted_at": "2025-01-02T12:15:30Z"
      },
      {
        "purpose": "sentiment_analysis",
        "granted": false,
        "granted_at": "2025-01-02T12:15:30Z"
      }
    ],
    "proof_mechanisms": [
      {
        "proof_type": "verbal_confirmation",
        "timestamp": "2025-01-02T12:15:30Z",
        "proof_data": {
          "dialog_reference": 0,
          "time_offset": "00:01:23",
          "confirmation_text": "Yes, I consent to recording this call"
        }
      }
    ],
    "terms_of_service": "https://example.com/terms/v2024.1",
    "status_interval": "30d",
    "consent_ledger": "https://transparency.example.com/consent/ledger"
  }
}
```

# Consent Processing Requirements

## Temporal Validity

Implementations MUST validate consent expiration before processing:

1. Compare current time against `expiration` timestamp
2. Account for reasonable clock skew (maximum 5 minutes recommended)
3. Reject processing if consent has expired
4. Support `null` expiration for indefinite consent subject to revalidation intervals

## Reference Validation

Implementations MUST validate attachment references:

1. Verify `party` index exists in vCon parties array
2. Verify `dialog` indices exist in vCon dialog array

## Granular Consent Evaluation

When processing vCon content, implementations MUST:

1. Check for applicable consent attachments for the requested processing purpose
2. Evaluate all relevant consent grants for the specific purpose
3. Apply most restrictive consent when multiple grants apply
4. Deny processing if no valid consent exists or if consent is explicitly denied

## Proof Verification

Implementations SHOULD verify proof mechanisms when present:

1. Validate cryptographic signatures using appropriate algorithms
2. Verify external document integrity using content hashes
3. Check external system consent status via API calls
4. Log proof verification results for audit purposes

# SCITT Transparency Integration

## Consent Ledger Services

The optional `consent_ledger` field enables integration with SCITT (Supply Chain Integrity, Transparency, and Trust) transparency services for consent audit trails.

When present, the consent ledger URL MUST:

- Reference a SCITT Transparency Service implementing SCRAPI [I-D.draft-ietf-scitt-scrapi-05]
- Provide cryptographic receipts for consent state changes
- Support consent status queries and updates
- Implement appropriate access controls and privacy protections

## Ledger Integration Requirements

Implementations that support consent ledgers MUST:

1. Use HTTPS with TLS 1.2 or higher for all communications
2. Implement appropriate authentication mechanisms
3. Validate SCITT receipts using standard verification procedures
4. Handle service unavailability gracefully
5. Cache consent state within configured intervals

## Privacy Considerations for Ledgers

Consent ledger services SHOULD:

- Store only consent metadata, not full conversation content
- Implement privacy-preserving query mechanisms
- Maintain audit logs for regulatory compliance
- Support consent deletion and other personal data compliance responsibilities

# Error Handling

Implementations SHOULD provide specific error reporting:

- **ConsentExpiredError**: Consent has expired and cannot be used
- **ConsentDeniedError**: Consent explicitly denies the requested processing
- **ConsentMissingError**: No valid consent found for the requested processing
- **ProofVerificationError**: Consent proof mechanisms failed validation
- **ReferenceValidationError**: Consent references invalid vCon elements

# Interoperability

To ensure interoperability across implementations:

- Use only standard JSON data types in consent body structures
- Support graceful degradation when advanced features are unavailable
- Implement consent attachment format negotiation for multi-party exchanges

# Security Considerations

The `vcon-core` specification provides general-purpose security mechanisms, such as digital signatures, designed to ensure the basic integrity of the vCon container. These mechanisms answer the question, "Has this vCon been tampered with?" However, managing consent requires addressing a more specific and legally significant question: "Did this specific person give valid permission for this specific action at a specific time?" Answering this question requires a higher level of security and contextual awareness. The following sections detail the additional security considerations that are critical for a consent mechanism to be considered trustworthy and compliant with privacy regulations.

## Cryptographic Protection and Consent Forgery

**Background:** Consent forgery is the act of creating a fake consent record or altering an existing one—for instance, by changing the expiration date, expanding the scope of what was agreed to, or faking the identity of the consenting party. The ability to prove that consent is authentic and unaltered is the bedrock of any privacy compliance framework like GDPR or CCPA. A forged consent record is equivalent to having no consent at all and carries severe legal and financial penalties. While `vcon-core` provides a `signature` field, the consent extension adds the necessary business rules to ensure that a signature represents a trusted, verifiable, and legally binding act.

**Requirements:** Implementations MUST prevent consent forgery through:

- Cryptographic signature verification for digital proof mechanisms.
- External document integrity validation using content hashes.
- Secure communication channels for external consent verification.
- Audit logging of all consent validation activities.

## Replay Attack Prevention

**Background:** A replay attack involves an attacker copying a valid consent attachment from one vCon and maliciously inserting it into a different vCon that the user never actually consented to. Without replay protection, a user's consent for a non-sensitive inquiry could be "replayed" to appear as if they consented to the recording and analysis of a highly sensitive conversation. This would be a massive privacy violation and would render the consent mechanism meaningless.

**Requirements:** The consent attachment design MUST prevent replay attacks through:

- Cryptographic binding to specific vCon instances.
- Timestamp validation with appropriate clock skew tolerance.
- Nonce inclusion in proof mechanisms where applicable.
- Reference validation to ensure consent applies to correct content.

## Secure Communication Channels

**Background:** Consent records are themselves sensitive personal data. It is critical that they are protected while in transit between systems. An attacker in a "man-in-the-middle" position could intercept a vCon and alter it before it reaches its destination, potentially stripping or modifying consent information.

**Requirements:** All consent attachments MUST be integrity protected using vCon signing mechanisms as defined in [I-D.draft-ietf-vcon-core-00]. Consent attachments containing sensitive information SHOULD be encrypted when transmitted outside secure environments, for instance by using TLS 1.2 or higher for all communications.

## Audit Logging

**Background:** Consent is a matter of legal and regulatory compliance. If a dispute arises, the organization processing the data must be able to *prove* it had valid consent at the time of the action. An audit log provides this crucial, non-repudiable evidence for regulators, auditors, and courts. It is a cornerstone of the "accountability" principle in modern privacy law.

**Requirements:** Systems that process or manage consent attachments SHOULD maintain a secure, immutable record of all consent-related activities (e.g., when consent was given, checked, revoked, or expired). When a `consent_ledger` is used, this requirement may be fulfilled by the ledger service.

# Privacy and Regulatory Compliance

## Data Minimization

Consent attachments MUST implement data minimization principles by:

- Including only information necessary for consent verification
- Avoiding duplication of personal data already in vCon elements
- Supporting consent attachment redaction while maintaining verifiability
- Implementing privacy-preserving verification mechanisms

## Regulatory Alignment

The consent extension addresses requirements from major privacy regulations:

- **GDPR Article 7**: Conditions for consent including withdrawal mechanisms
- **CCPA Section 1798.135**: Consent requirements for personal information processing
- **HIPAA Privacy Rule**: Consent requirements for protected health information

Implementers MUST ensure their implementations comply with applicable regulations in their jurisdiction.

## Data Subject Rights

Implementations MUST support data subject rights including:

- **Right of Access**: Enable data subjects to access their consent records
- **Right of Rectification**: Allow correction of inaccurate consent information
- **Right to be Forgotten**: Support consent deletion and data erasure
- **Right of Portability**: Enable export of consent data in interoperable formats
- **Consent Withdrawal**: Provide mechanisms for consent revocation

# Conclusion

This document defines a comprehensive consent extension for vCon that balances privacy protection with practical implementation requirements. The extension provides a foundation for consent-aware conversation processing while maintaining compatibility with existing vCon infrastructure.

# IANA Considerations

## vCon Extensions Names Registry

This document requests IANA to register the following extension in the vCon Extensions Names Registry established by [I-D.draft-ietf-vcon-core-00]:

- **Extension Name**: consent
- **Extension Description**: Consent management for voice conversation participants with cryptographic proof mechanisms and regulatory compliance support
- **Change Controller**: IESG
- **Specification Document(s)**: [this document]

## Attachment Object Parameter Names Registry

This document requests IANA to register the following parameter in the Attachment Object Parameter Names Registry:

- **Parameter Name**: type
- **Parameter Description**: Semantic type identifier for attachment content
- **Change Controller**: IESG
- **Specification Document(s)**: [this document], Section 4

Note: This addresses the "TODO: type or purpose" noted in Section 6.3.6 of [I-D.draft-ietf-vcon-core-00].

## Consent Attachment Type Values Registry

This document requests IANA to establish a new registry for consent attachment type values with the following initial registration:

- **Type Value**: consent
- **Description**: Structured consent records with temporal validity and cryptographic proof mechanisms
- **Change Controller**: IESG
- **Specification Document(s)**: [this document]

Registration Template:

**Type Value**: The string value used as the attachment type identifier

**Description**: Brief description of the attachment type and its purpose

**Change Controller**: For Standards Track RFCs, list "IESG". For others, give the name of the responsible party.

**Specification Document(s)**: Reference to defining documents with URIs where available


# Security and Privacy Considerations Summary

This consent extension addresses several critical security and privacy concerns:

**Consent Integrity**: Cryptographic protection prevents unauthorized modification of consent records while maintaining verifiability across system boundaries.

**Temporal Security**: Expiration controls and revalidation intervals ensure consent cannot be misused beyond its intended temporal scope.

**Audit Transparency**: SCITT integration provides cryptographic audit trails for consent operations while maintaining privacy protections.

**Regulatory Compliance**: Structured consent management supports compliance with GDPR, CCPA, HIPAA and other privacy regulations through standardized metadata and processing controls.

**Data Minimization**: Privacy-preserving design minimizes data collection and supports consent-driven access controls throughout the conversation lifecycle.

Implementers should conduct thorough security reviews and ensure compliance with applicable privacy regulations in their deployment environments.

--- back

# Acknowledgements

- Appreciation to Vinnie Micciche for his unwavering support during the development of this consent attachment in particular, and vCons in general.
