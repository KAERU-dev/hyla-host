# Security

Hyla Host is a fork of [Apollo](https://github.com/ClassicOldSong/Apollo), which
is a fork of [Sunshine](https://github.com/LizardByte/Sunshine). Most of the
host's network-facing code (pairing, the GameStream HTTP servers, the control
and input streams, the Web UI) comes from Sunshine, so Sunshine's security
advisories are the main source of known vulnerabilities for this fork. Apollo
does not backport them on a schedule, so this fork tracks them itself.

## How Sunshine advisories are tracked

Sunshine publishes its advisories at
<https://github.com/LizardByte/Sunshine/security/advisories>.

1. **Detection.** The [Sunshine advisories](.github/workflows/sunshine-advisories.yml)
   workflow runs daily (and on demand). It lists Sunshine's published advisories
   through the GitHub API and fails when an advisory ID is missing from the
   backport log below. A failed run is the signal that a new advisory needs
   handling. GitHub pauses scheduled workflows in repositories without
   activity for 60 days; re-enable it from the Actions tab if that happens.
2. **Assessment.** Read the advisory, find Sunshine's fix (security fixes land
   as `Merge commit from fork` commits in the patched release), and check
   whether this fork's code has the same flaw. Apollo's code has diverged from
   Sunshine, so check the behaviour, not only the file names.
3. **Backport.** Port the fix as one commit per advisory, with the GHSA ID in the
   commit message, adapted to this fork's code. Port Sunshine's tests for the
   fix when the test framework here supports them. Do not add fixes Sunshine
   did not make, and do not publish exploit details: commit messages and this
   file link the public advisory and describe the fix at the level of the
   advisory text.
4. **Log.** Add a row to the backport log in the same pull request. Use one of
   these statuses:
   - **Backported**: fixed by the linked commit in this fork.
   - **Inherited**: the fix was already in the Apollo base this fork started
     from.
   - **Not applicable**: this fork is not affected; the row says why and what
     would make it applicable.

Only add a row once the advisory is handled. An advisory under assessment has
no row, so the check keeps failing until it is resolved.

## Release rule

Hyla Launcher ships this host. **A Sunshine advisory that is published but
missing from the backport log blocks the next Hyla release that ships the
host**, as does a failing run of the advisory check on `master`. Release notes
for a host build list the advisories included since the previous release.

## Backport log

Sunshine fix commits are in
[LizardByte/Sunshine](https://github.com/LizardByte/Sunshine); fork commits
are in this repository.

| Advisory | Severity | Sunshine fix | Status | Hyla Host |
| --- | --- | --- | --- | --- |
| [GHSA-fp6g-27w5-489j](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-fp6g-27w5-489j) | High | v2026.914.233613 (`c553565b`) | Not applicable | Linux only: concerns GUI module-loader environment variables in a process with Linux file capabilities. Hyla Host builds and ships Windows only. Backport before any Linux build. |
| [GHSA-c428-87f8-rrv5](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-c428-87f8-rrv5) | Medium | v2026.906.222525 (`82bccdf6`) | Backported | [`be38c64c`](https://github.com/KAERU-dev/hyla-host/commit/be38c64c8b89ac8f3422a1a9a2305a7a466c05ff), tests ported |
| [GHSA-26q2-58j6-qmvv](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-26q2-58j6-qmvv) | High | v2026.906.222525 (`1583e7c4`) | Backported | [`f50ce347`](https://github.com/KAERU-dev/hyla-host/commit/f50ce347ff1cb5ff2d4359bc320b6cd00e0137e6), tests ported. Sunshine fixed this and GHSA-6w33-pjh7-p77c in one change. |
| [GHSA-36ff-frg7-492f](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-36ff-frg7-492f) | High | v2026.906.222525 (`ccf97e38`) | Backported | [`b97c4839`](https://github.com/KAERU-dev/hyla-host/commit/b97c4839048e724901c6a3902b9ddb428506c4fb), tests ported. The PIN page now asks which pending device to approve. |
| [GHSA-6jvv-jqr7-m6m3](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-6jvv-jqr7-m6m3) | High | v2026.906.222525 (`4d768847`) | Not applicable | The advisory concerns bypassing Sunshine's per-client Disable control, added in Sunshine 2026.329.165800. Apollo has no such control: a paired client is either paired or removed, and a certificate derived from a paired one resolves to that same client and its permissions. Removing a client removes its trust. Backport if a disable control is added. |
| [GHSA-6w33-pjh7-p77c](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-6w33-pjh7-p77c) | High | v2026.906.222525 (`1583e7c4`) | Backported | [`f50ce347`](https://github.com/KAERU-dev/hyla-host/commit/f50ce347ff1cb5ff2d4359bc320b6cd00e0137e6), tests ported. Same change as GHSA-26q2-58j6-qmvv. |
| [GHSA-ph75-mgxh-mv57](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-ph75-mgxh-mv57) | Critical | v2026.516.143833 (`888a6bb0`) | Inherited | Apollo `9fc623dd` |
| [GHSA-6p7j-5v8v-w45h](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-6p7j-5v8v-w45h) | Medium | v2025.923.33222 (`f22b00d6`) | Inherited | In Apollo's history; the service path is quoted in `install-service.bat`. |
| [GHSA-x97g-h2vp-g2c5](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-x97g-h2vp-g2c5) | Medium | 2025.628.4510 (`2f27a57d`) | Inherited | In Apollo's history; Web UI responses forbid framing. |
| [GHSA-39hj-fxvw-758m](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-39hj-fxvw-758m) | Critical | 2025.628.4510 (`738ac93a`) | Inherited | In Apollo's history; Apollo's Web UI also authenticates with a `SameSite=Strict` session cookie. |
| [GHSA-3hrw-xv8h-9499](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-3hrw-xv8h-9499) | High | 2025.118.151840 (`89f097ae`) | Inherited | In Apollo's history; pairing phases are enforced in order. |
| [GHSA-jqph-8cp5-g874](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-jqph-8cp5-g874) | Medium | v2024.910.1354 (`fd7e6845`) | Inherited | In Apollo's history; a client certificate is stored only after the final pairing phase verifies. |
| [GHSA-r3rw-mx4q-7vfp](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-r3rw-mx4q-7vfp) | Medium | v0.23.0 | Inherited | `tools/sunshinesvc.cpp` passes the module path explicitly and quotes the command line. |
| [GHSA-v8gw-jw28-v55m](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-v8gw-jw28-v55m) | Medium | v0.23.0 | Inherited | Unpairing all clients clears the certificate chain. |
| [GHSA-6rg7-7m3w-w5wc](https://github.com/LizardByte/Sunshine/security/advisories/GHSA-6rg7-7m3w-w5wc) | Medium | 0.18.0 | Inherited | The `node_modules` route only serves files inside the Web UI directory. |

## Reporting a vulnerability

If a vulnerability also affects Sunshine, report it to LizardByte through
[Sunshine's security policy](https://github.com/LizardByte/Sunshine/security).
This repository does not have a private reporting channel of its own yet.
