---
title: "vCon Lawful Basis"
abbrev: "vCon Lawful Basis"
category: std
docname: draft-howe-vcon-lawful-basis-00
replaces: draft-howe-vcon-consent-00
ipr: trust200902
area: "Applications and Real-Time"
workgroup: "vCon"
keyword: Internet-Draft
venue:
  group: "vCon"
  type: "Working Group"
  mail: "vcon@ietf.org"
  arch: "https://mailarchive.ietf.org/arch/browse/vcon/"
  github: "vcon-dev/draft-howe-vcon-lawful-basis"
  latest: "https://vcon-dev.github.io/draft-howe-vcon-consent/draft-howe-vcon-lawful-basis-latest.html"

stand_alone: yes
smart_quotes: no
pi: [toc, sortrefs, symrefs]

author:
 -
    name: Thomas McCarthy-Howe
    organization: Strolid
    email: ghostofbasho@gmail.com

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

  RFC8785:
    target: https://www.rfc-editor.org/rfc/rfc8785.html
    title: "JSON Canonicalization Scheme (JCS)"
    author:
      name: A. Rundgren
      ins: A. Rundgren
      org: Independent
    date: June 2020

  RFC7693:
    target: https://www.rfc-editor.org/rfc/rfc7693.html
    title: "The BLAKE2 Cryptographic Hash and Message Authentication Code (MAC)"
    author:
      name: M. Saarinen
      ins: M. Saarinen
      org: Independent
    date: November 2015

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

  FIPS-180-4:
    target: https://csrc.nist.gov/publications/detail/fips/180/4/final
    title: "Secure Hash Standard (SHS)"
    author:
      org: National Institute of Standards and Technology
    date: August 2015

  FIPS-202:
    target: https://csrc.nist.gov/publications/detail/fips/202/final
    title: "SHA-3 Standard: Permutation-Based Hash and Extendable-Output Functions"
    author:
      org: National Institute of Standards and Technology
    date: August 2015

--- abstract

This document defines a lawful basis extension for Virtualized Conversations (vCon) that provides standardized mechanisms for recording, verifying, and managing the lawful basis for processing data within conversation containers. The lawful basis extension addresses privacy compliance challenges through structured attachment metadata, including the specific lawful basis being asserted, temporal validity periods where applicable, and cryptographic proof mechanisms.

The extension is designed as a Compatible vCon extension that introduces lawful basis management capabilities without altering existing vCon semantics. It defines a "lawful_basis" attachment type with structured records for each of the six lawful bases defined in regulations like GDPR, including consent, contract, legal obligation, vital interests, public task, and legitimate interests.

Key features include automated lawful basis detection during conversation processing, auditable records with cryptographic proofs, granular purpose-based permissions for all lawful bases, documented justifications for other lawful bases, and integration with privacy regulations including GDPR, CCPA, and HIPAA.

--- middle

# Introduction

Conversations originating from all modes (voice, video, email, fax and messaging), contain sensitive information that requires a documented lawful basis for processing to comply with privacy regulations and ethical standards. This document defines a lawful basis extension for Virtualized Conversations (vCon) that enables automated lawful basis detection, structured recording, and cryptographic proof mechanisms.

A vCon (Virtualized Conversation) is a standardized container format for storing conversation data, including metadata, participants, and conversation content, as defined in [I-D.draft-ietf-vcon-core-00]. The vCon specification supports extensible attachments that can carry additional structured data related to the conversation.

This lawful basis extension provides a Compatible vCon extension (as defined in Section 2.5 of [I-D.draft-ietf-vcon-core-00]) that introduces lawful basis management capabilities through a standardized "lawful_basis" attachment type. The extension captures essential metadata including:

- The specific lawful basis being asserted for processing
- Party identification (for consent-based processing)
- Temporal validity periods (where applicable)
- Granular purpose-based permissions
- Documented justifications for non-consent-based lawful bases
- Cryptographic proof mechanisms and external verification
- Integration with SCITT transparency services for audit trails

The lawful basis extension addresses key privacy and compliance challenges while maintaining compatibility with existing vCon implementations. Implementations that do not recognize the lawful basis extension can safely ignore lawful basis attachments while maintaining valid processing of other vCon content.

# Conventions and Definitions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 [RFC2119] [RFC8174] when, and only when, they appear in all capitals, as shown here.

## Core Terms

**Lawful Basis**: A valid justification, as defined by applicable law (e.g., GDPR), for the processing of personal data. One of six potential bases must be identified prior to processing.

**Data Subject**: The identified or identifiable natural person to whom personal data relates [GDPR].

**Lawful Basis Attachment**: A vCon attachment with type "lawful_basis" that contains structured information documenting the lawful basis for processing conversation data.

**Attestation Registry**: An external transparency service that maintains an authoritative, verifiable log of attestations about a vCon, which can include attestations of a lawful basis. This document defines integration with registries using the SCITT protocol.

**Compatible Extension**: A vCon extension that introduces additional data without altering the meaning or structure of existing elements, as defined in [I-D.draft-ietf-vcon-core-00].

# Overview of Lawful Bases

While this document defines an extension for recording any lawful basis for processing, it is important to understand the distinctions between them. Under regulations like the GDPR, there are six lawful bases for processing personal data. Consent is unique in that it is a permission granted by the data subject, while the other five are justifications asserted by the data controller. Understanding this distinction is critical for correctly implementing this extension.

The six lawful bases for processing under GDPR are:

1.  **Consent**: The data subject has given clear, unambiguous consent for their personal data to be processed for a specific purpose. This basis is unique because it originates with the data subject.

2.  **Contract**: The processing is necessary for a contract that the data subject has with the organization, or because they have asked the organization to take specific steps before entering into a contract. For example, processing a customer's address to deliver a purchased product.

3.  **Legal Obligation**: The processing is necessary for the organization to comply with the law (not including contractual obligations). For example, a financial institution may be legally required to report certain transactions to prevent fraud.

4.  **Vital Interests**: The processing is necessary to protect someone's life. For example, sharing a patient's medical history with emergency services.

5.  **Public Task**: The processing is necessary for the organization to perform a task in the public interest or for its official functions, and the task or function has a clear basis in law. For example, a local authority processing data to provide public services.

6.  **Legitimate Interests**: The processing is necessary for the organization's legitimate interests or the legitimate interests of a third party, unless there is a good reason to protect the individual's personal data which overrides those legitimate interests. For example, a business using customer data for marketing analysis to improve its services, provided it does not infringe on the customer's privacy rights.

This lawful basis extension for vCon provides a standardized way to record and verify any of these lawful bases. The presence and content of a `lawful_basis` attachment are intended to be the primary mechanism for determining the authorized uses of a vCon's data.

# vCon Lawful Basis Extension Definition

## Extension Classification

The lawful basis extension is a **Compatible Extension** as defined in Section 2.5 of [I-D.draft-ietf-vcon-core-00]. This extension:

- Introduces additional lawful basis metadata without altering existing vCon semantics
- Can be safely ignored by implementations that don't support lawful basis processing
- Does not require listing in the `must_support` parameter
- Maintains backward compatibility with existing vCon implementations

## Extension Registration

This document defines the "lawful_basis" extension token for registration in the vCon Extensions Names Registry:

- **Extension Name**: lawful_basis
- **Extension Description**: Lawful basis management for conversation participants with cryptographic proof mechanisms and regulatory compliance support
- **Change Controller**: IESG
- **Specification Document**: This document

## Extension Usage

vCon instances that include lawful basis attachments SHOULD include "lawful_basis" in the `extensions` array:

```json
{
  "uuid": "01234567-89ab-cdef-0123-456789abcdef",
  "extensions": ["lawful_basis"],
  "created_at": "2025-01-02T12:00:00Z",
  "parties": [...],
  "dialog": [...],
  "attachments": [
    {
      "type": "lawful_basis",
      "start": "2025-01-02T12:15:30Z",
      "party": 0,
      "dialog": 0,
      "encoding": "json",
      "body": {
        // Lawful basis data structure defined below
      }
    }
  ]
}
```

# Lawful Basis Attachment Structure

## Attachment Container

Lawful basis information MUST be included as vCon attachments using the standard attachment object structure defined in Section 4.4 of [I-D.draft-ietf-vcon-core-00].

The lawful basis attachment MUST include:

- **type**: MUST be set to "lawful_basis"
- **encoding**: MUST be set to "json" for structured lawful basis data
- **body**: MUST contain the lawful basis data structure as defined below

The lawful basis attachment SHOULD include:

- **start**: ISO 8601 timestamp when lawful basis was recorded
- **party**: Index of the party in the vCon parties array
- **dialog**: Index of the associated dialog in the vCon dialog array

## Lawful Basis Body Structure

The `body` field of the lawful basis attachment MUST contain a JSON object with the following structure:

### Required Fields

- **lawful_basis**: String enum from `consent`, `contract`, `legal_obligation`, `vital_interests`, `public_task`, `legitimate_interests`
- **expiration**: ISO 8601 timestamp indicating when the lawful basis expires, or `null` for indefinite
- **purpose_grants**: Array of purpose grant objects specifying permissions

### Optional Fields

- **terms_of_service**: URL reference to applicable terms of service document
- **status_interval**: Duration string for revalidation intervals (e.g., "30d")
- **content_hash**: An object containing content integrity information for the lawful basis attachment. The object has the following fields:
  - **algorithm**: (string, required) The hash algorithm used. This document defines initial values of "sha-256", "sha-3-256", and "blake2b-256". Other values may be registered in an IANA registry.
  - **canonicalization**: (string, required) The canonicalization method used. This document defines an initial value of "jcs" (JSON Canonicalization Scheme per RFC 8785). Other values may be registered in an IANA registry.
  - **value**: (string, required) The hexadecimal-encoded hash value of the canonicalized lawful basis attachment body.
- **registry**: An object containing information about an external attestation registry for audit trails. The object has the following fields:
  - **type**: (string, required) The type of the attestation registry service. This document defines an initial value of "scitt". Other values may be registered in an IANA registry.
  - **url**: (string, required) The URL endpoint for the attestation registry service.
- **proof_mechanisms**: Array of proof objects supporting the lawful basis
- **metadata**: Additional implementation-specific metadata

### Purpose Grant Objects

Each object in the `purpose_grants` array MUST contain:

- **purpose**: String identifying the processing purpose (e.g., "recording", "transcription", "analysis")
- **granted**: Boolean indicating whether permission is granted (true) or denied (false)
- **granted_at**: ISO 8601 timestamp when this specific permission was granted
- **conditions**: Optional array of strings describing conditions or restrictions

### Proof Mechanism Objects

Each object in the `proof_mechanisms` array MUST contain:

- **proof_type**: String identifying the proof mechanism type
- **timestamp**: ISO 8601 timestamp when proof was created
- **proof_data**: Object containing proof-type-specific data

Supported proof types include:

- **verbal_confirmation**: Lawful basis given verbally within the conversation
- **signed_document**: External signed lawful basis form or agreement
- **cryptographic_signature**: Digital signature using COSE standards
- **external_system**: Lawful basis recorded in external system with API verification

## Example Lawful Basis Attachment

```json
{
  "type": "lawful_basis",
  "start": "2025-01-02T12:15:30Z",
  "party": 0,
  "dialog": 0,
  "encoding": "json",
  "body": {
    "lawful_basis": "consent",
    "expiration": "2026-01-02T12:00:00Z",
    "purpose_grants": [
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
    "content_hash": {
      "algorithm": "sha-256",
      "canonicalization": "jcs",
      "value": "a1b2c3d4e5f6789abcdef0123456789abcdef0123456789abcdef0123456789ab"
    },
    "registry": {
      "type": "scitt",
      "url": "https://transparency.example.com/lawful_purpose/registry"
    }
  }
}
```

# Lawful Basis Processing Requirements

## Content Hash Validation

Implementations MUST validate content hashes when present in lawful basis attachments:

1. **Canonicalization**: Apply the specified canonicalization method to the lawful basis attachment body
   - For "jcs" canonicalization: Use JSON Canonicalization Scheme per RFC 8785
   - Sort object keys lexicographically
   - Remove insignificant whitespace
   - Ensure consistent number representations

2. **Hash Computation**: Compute the hash using the specified algorithm
   - For "sha-256": Use SHA-256 algorithm
   - For "sha-3-256": Use SHA-3-256 algorithm
   - For "blake2b-256": Use BLAKE2b-256 algorithm

3. **Hash Verification**: Compare computed hash with the provided value
   - Reject processing if hashes do not match
   - Log hash validation results for audit purposes

4. **Error Handling**: Provide specific error reporting for hash validation failures
   - **ContentHashMismatchError**: Computed hash does not match provided value
   - **UnsupportedHashAlgorithmError**: Hash algorithm not supported by implementation
   - **UnsupportedCanonicalizationError**: Canonicalization method not supported by implementation

## Temporal Validity

Implementations MUST validate lawful basis expiration before processing:

1. Compare current time against `expiration` timestamp
2. Account for reasonable clock skew (maximum 5 minutes recommended)
3. Reject processing if lawful basis has expired
4. Support `null` expiration for indefinite validity subject to revalidation intervals

## Reference Validation

Implementations MUST validate attachment references:

1. Verify `party` index exists in vCon parties array
2. Verify `dialog` indices exist in vCon dialog array

## Granular Permission Evaluation

When processing vCon content, implementations MUST:

1. Check for applicable lawful basis attachments for the requested processing purpose
2. Evaluate all relevant purpose grants for the specific purpose
3. Apply most restrictive permission when multiple grants apply
4. Deny processing if no valid permission exists or if it is explicitly denied

## Proof Verification

Implementations SHOULD verify proof mechanisms when present:

1. Validate cryptographic signatures using appropriate algorithms
2. Verify external document integrity using content hashes
3. Check external system lawful basis status via API calls
4. Log proof verification results for audit purposes

# Transparency Service Integration

## Registry Services

The optional `registry` field enables integration with external attestation registries for audit trails. The `registry` object's `type` field specifies the protocol to be used.

When the `registry` object is present and its `type` is "scitt", the `url` field MUST:

- Reference a SCITT (Supply Chain Integrity, Transparency, and Trust) Transparency Service implementing SCRAPI [I-D.draft-ietf-scitt-scrapi-05]
- Provide cryptographic receipts for state changes
- Support status queries and updates
- Implement appropriate access controls and privacy protections

Other transparency service types may be used if they are registered with IANA. The documentation for each registered type must specify the necessary protocols and interaction models.

## Registry Integration Requirements

Implementations that support registries MUST:

1. Use HTTPS with TLS 1.2 or higher for all communications
2. Implement appropriate authentication mechanisms
3. Validate SCITT receipts using standard verification procedures
4. Handle service unavailability gracefully
5. Cache lawful basis state within configured intervals

## Privacy Considerations for Registries

Registry services SHOULD:

- Store only lawful basis metadata, not full conversation content
- Implement privacy-preserving query mechanisms
- Maintain audit logs for regulatory compliance
- Support deletion and other personal data compliance responsibilities

# Error Handling

Implementations SHOULD provide specific error reporting:

- **LawfulBasisExpiredError**: Lawful basis has expired and cannot be used
- **PermissionDeniedError**: Permission explicitly denies the requested processing
- **LawfulBasisMissingError**: No valid lawful basis found for the requested processing
- **ProofVerificationError**: Lawful basis proof mechanisms failed validation
- **ReferenceValidationError**: Attachment references invalid vCon elements
- **ContentHashMismatchError**: Computed hash does not match provided value
- **UnsupportedHashAlgorithmError**: Hash algorithm not supported by implementation
- **UnsupportedCanonicalizationError**: Canonicalization method not supported by implementation

# Interoperability

To ensure interoperability across implementations:

- Use only standard JSON data types in lawful basis body structures
- Support graceful degradation when advanced features are unavailable
- Implement lawful basis attachment format negotiation for multi-party exchanges

# Security Considerations

The `vcon-core` specification provides general-purpose security mechanisms, such as digital signatures, designed to ensure the basic integrity of the vCon container. These mechanisms answer the question, "Has this vCon been tampered with?" However, managing lawful basis requires addressing a more specific and legally significant question: "Did this specific person provide a valid basis for this specific action at a specific time?" Answering this question requires a higher level of security and contextual awareness. The following sections detail the additional security considerations that are critical for a lawful basis mechanism to be considered trustworthy and compliant with privacy regulations.

## Cryptographic Protection and Forgery

**Background:** Forgery is the act of creating a fake record or altering an existing one—for instance, by changing the expiration date, expanding the scope of what was agreed to, or faking the identity of the party. The ability to prove that a lawful basis is authentic and unaltered is the bedrock of any privacy compliance framework like GDPR or CCPA. A forged record is equivalent to having no lawful basis at all and carries severe legal and financial penalties. While `vcon-core` provides a `signature` field, this extension adds the necessary business rules to ensure that a signature represents a trusted, verifiable, and legally binding act.

**Requirements:** Implementations MUST prevent forgery through:

- Cryptographic signature verification for digital proof mechanisms.
- External document integrity validation using content hashes.
- Secure communication channels for external verification.
- Audit logging of all validation activities.

## Replay Attack Prevention

**Background:** A replay attack involves an attacker copying a valid lawful basis attachment from one vCon and maliciously inserting it into a different vCon that the user never actually provided a basis for. Without replay protection, a user's lawful basis for a non-sensitive inquiry could be "replayed" to appear as if they provided it for the recording and analysis of a highly sensitive conversation. This would be a massive privacy violation and would render the mechanism meaningless.

**Requirements:** The lawful basis attachment design MUST prevent replay attacks through:

- Cryptographic binding to specific vCon instances.
- Timestamp validation with appropriate clock skew tolerance.
- Nonce inclusion in proof mechanisms where applicable.
- Reference validation to ensure lawful basis applies to correct content.

## Secure Communication Channels

**Background:** Lawful basis records are themselves sensitive personal data. It is critical that they are protected while in transit between systems. An attacker in a "man-in-the-middle" position could intercept a vCon and alter it before it reaches its destination, potentially stripping or modifying lawful basis information.

**Requirements:** All lawful basis attachments MUST be integrity protected using vCon signing mechanisms as defined in [I-D.draft-ietf-vcon-core-00]. Lawful basis attachments containing sensitive information SHOULD be encrypted when transmitted outside secure environments, for instance by using TLS 1.2 or higher for all communications.

## Audit Logging

**Background:** Lawful basis is a matter of legal and regulatory compliance. If a dispute arises, the organization processing the data must be able to *prove* it had a valid lawful basis at the time of the action. An audit log provides this crucial, non-repudiable evidence for regulators, auditors, and courts. It is a cornerstone of the "accountability" principle in modern privacy law.

**Requirements:** Systems that process or manage lawful basis attachments SHOULD maintain a secure, immutable record of all related activities (e.g., when a lawful basis was given, checked, revoked, or expired). When a `registry` is used, this requirement may be fulfilled by the registry service.

# Privacy and Regulatory Compliance

## Data Minimization

Lawful basis attachments MUST implement data minimization principles by:

- Including only information necessary for verification
- Avoiding duplication of personal data already in vCon elements
- Supporting attachment redaction while maintaining verifiability
- Implementing privacy-preserving verification mechanisms

## Regulatory Alignment

The lawful basis extension addresses requirements from major privacy regulations:

- **GDPR Article 7**: Conditions for lawful basis including withdrawal mechanisms
- **CCPA Section 1798.135**: Requirements for personal information processing
- **HIPAA Privacy Rule**: Requirements for protected health information

Implementers MUST ensure their implementations comply with applicable regulations in their jurisdiction.

## Data Subject Rights

Implementations MUST support data subject rights including:

- **Right of Access**: Enable data subjects to access their records
- **Right of Rectification**: Allow correction of inaccurate information
- **Right to be Forgotten**: Support deletion and data erasure
- **Right of Portability**: Enable export of data in interoperable formats
- **Withdrawal**: Provide mechanisms for revocation of a lawful basis

# Conclusion

This document defines a comprehensive lawful basis extension for vCon that balances privacy protection with practical implementation requirements. The extension provides a foundation for lawful basis-aware conversation processing while maintaining compatibility with existing vCon infrastructure.

# Security and Privacy Considerations Summary

This lawful basis extension addresses several critical security and privacy concerns:

**Integrity**: Cryptographic protection prevents unauthorized modification of records while maintaining verifiability across system boundaries.

**Temporal Security**: Expiration controls and revalidation intervals ensure a lawful basis cannot be misused beyond its intended temporal scope.

**Audit Transparency**: SCITT integration provides cryptographic audit trails for operations while maintaining privacy protections.

**Regulatory Compliance**: Structured management supports compliance with GDPR, CCPA, HIPAA and other privacy regulations through standardized metadata and processing controls.

**Data Minimization**: Privacy-preserving design minimizes data collection and supports lawful basis-driven access controls throughout the conversation lifecycle.

Implementers should conduct thorough security reviews and ensure compliance with applicable privacy regulations in their deployment environments.

--- back

# IANA Considerations

## vCon Extensions Names Registry

This document requests IANA to register the following extension in the vCon Extensions Names Registry established by [I-D.draft-ietf-vcon-core-00]:

- **Extension Name**: lawful_basis
- **Extension Description**: Lawful basis management for conversation participants with cryptographic proof mechanisms and regulatory compliance support
- **Change Controller**: IESG
- **Specification Document(s)**: RFC XXXX

## Attachment Object Parameter Names Registry

This document requests IANA to register the following parameter in the Attachment Object Parameter Names Registry:

- **Parameter Name**: type
- **Parameter Description**: Semantic type identifier for attachment content
- **Change Controller**: IESG
- **Specification Document(s)**: RFC XXXX, Section 4

Note: This addresses the "TODO: type or purpose" noted in Section 6.3.6 of [I-D.draft-ietf-vcon-core-00].

## Lawful Basis Attachment Type Values Registry

This document requests IANA to establish a new registry for lawful basis attachment type values with the following initial registration:

- **Type Value**: lawful_basis
- **Description**: Structured lawful purpose records with temporal validity and cryptographic proof mechanisms
- **Change Controller**: IESG
- **Specification Document(s)**: RFC XXXX

Registration Template:

**Type Value**: The string value used as the attachment type identifier

**Description**: Brief description of the attachment type and its purpose

**Change Controller**: For Standards Track RFCs, list "IESG". For others, give the name of the responsible party.

**Specification Document(s)**: Reference to defining documents with URIs where available
## Lawful Basis Registry Type Values Registry

This document requests IANA to establish a new registry for lawful basis registry type values with the following initial registration:

- **Type Value**: scitt
- **Description**: A transparency service implementing the SCITT (Supply Chain Integrity, Transparency, and Trust) protocol.
- **Change Controller**: IESG
- **Specification Document(s)**: RFC XXXX, [I-D.draft-ietf-scitt-scrapi-05]

Registration Template:

**Type Value**: The string value used as the registry type identifier

**Description**: Brief description of the registry type and its purpose

**Change Controller**: For Standards Track RFCs, list "IESG". For others, give the name of the responsible party.

**Specification Document(s)**: Reference to defining documents with URIs where available

## Lawful Basis Content Hash Algorithm Values Registry

This document requests IANA to establish a new registry for lawful basis content hash algorithm values with the following initial registrations:

- **Algorithm Value**: sha-256
- **Description**: SHA-256 hash algorithm as defined in FIPS 180-4
- **Change Controller**: IESG
- **Specification Document(s)**: RFC XXXX, [FIPS-180-4]

- **Algorithm Value**: sha-3-256
- **Description**: SHA-3-256 hash algorithm as defined in FIPS 202
- **Change Controller**: IESG
- **Specification Document(s)**: RFC XXXX, [FIPS-202]

- **Algorithm Value**: blake2b-256
- **Description**: BLAKE2b-256 hash algorithm as defined in RFC 7693
- **Change Controller**: IESG
- **Specification Document(s)**: RFC XXXX, [RFC7693]

Registration Template:

**Algorithm Value**: The string value used as the hash algorithm identifier

**Description**: Brief description of the hash algorithm and its purpose

**Change Controller**: For Standards Track RFCs, list "IESG". For others, give the name of the responsible party.

**Specification Document(s)**: Reference to defining documents with URIs where available

## Lawful Basis Content Hash Canonicalization Values Registry

This document requests IANA to establish a new registry for lawful basis content hash canonicalization values with the following initial registration:

- **Canonicalization Value**: jcs
- **Description**: JSON Canonicalization Scheme as defined in RFC 8785
- **Change Controller**: IESG
- **Specification Document(s)**: RFC XXXX, [RFC8785]

Registration Template:

**Canonicalization Value**: The string value used as the canonicalization method identifier

**Description**: Brief description of the canonicalization method and its purpose

**Change Controller**: For Standards Track RFCs, list "IESG". For others, give the name of the responsible party.

**Specification Document(s)**: Reference to defining documents with URIs where available

# Acknowledgements

- Appreciation to Vinnie Micciche for his unwavering support during the development of this lawful basis attachment in particular, and vCons in general.
