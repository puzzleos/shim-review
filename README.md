This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag
- approval is ready when the "accepted" label is added to your issue

Note that we really only have experience with using GRUB2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

-------------------------------------------------------------------------------
### What organization or people are asking to have this signed?
-------------------------------------------------------------------------------

Cisco Systems, Inc.

-------------------------------------------------------------------------------
### What product or service is this for?
-------------------------------------------------------------------------------

PuzzleOS, a Linux based appliance OS used in a number of Cisco products.

-------------------------------------------------------------------------------
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
-------------------------------------------------------------------------------

The OS is designed to run on any platform that supports UEFI Secure Boot
and the easiest way to support the largest number of systems is to have
a shim bootloader signed by Microsoft.`

-------------------------------------------------------------------------------
### Who is the primary contact for security updates, etc.?
-------------------------------------------------------------------------------

- Name: Joy Latten
- Position: Software Engineer, Cisco
- Email address: jlatten@cisco.com, j_latten@yahoo.com
- PGP key fingerprint: 69F6FB67EC498FD5DA65C7D406B1CD452D3AE896

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

-------------------------------------------------------------------------------
### Who is the secondary contact for security updates, etc.?
-------------------------------------------------------------------------------

- Name: Serge Hallyn
- Position: Principal Engineer, Cisco
- Email address: shallyn@cisco.com, sergeh@kernel.org
- PGP key fingerprint: 66D0387DB85D320F8408166DB175CFA98F192AF2

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

-------------------------------------------------------------------------------
### Were these binaries created from the 15.6 shim release tar?
Please create your shim binaries starting with the 15.6 shim release tar file: https://github.com/rhboot/shim/releases/download/15.6/shim-15.6.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.6 and contains the appropriate gnu-efi source.

-------------------------------------------------------------------------------

Yes, our source is the 15.6 shim release tar file.

-------------------------------------------------------------------------------
### URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------

https://github.com/rhboot/shim/releases/download/15.6/shim-15.6.tar.bz2

-------------------------------------------------------------------------------
### What patches are being applied and why:
-------------------------------------------------------------------------------

None.

-------------------------------------------------------------------------------
### If shim is loading GRUB2 bootloader what exact implementation of Secureboot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
-------------------------------------------------------------------------------

We do not use GRUB2 as a second stage loader. Our Linux kernel, initramfs, and
kernel command line are bundled into a single EFI binary such that the PE/COFF
signature protects all of those components. We use a small EFI stub based on
the systemd-boot stub, to do this and we have augmented it to add support
for a SBAT section. The "stubby" uefi bootloader source is located at
https://github.com/puzzleos/stubby. Our shim will boot the Linux kernel.

-------------------------------------------------------------------------------
### If shim is loading GRUB2 bootloader and your previously released shim booted a version of grub affected by any of the CVEs in the July 2020 grub2 CVE list, the March 2021 grub2 CVE list, or the June 7th 2022 grub2 CVE list:
* CVE-2020-14372
* CVE-2020-25632
* CVE-2020-25647
* CVE-2020-27749
* CVE-2020-27779
* CVE-2021-20225
* CVE-2021-20233
* CVE-2020-10713
* CVE-2020-14308
* CVE-2020-14309
* CVE-2020-14310
* CVE-2020-14311
* CVE-2020-15705
* CVE-2021-3418 (if you are shipping the shim_lock module)

* CVE-2021-3695
* CVE-2021-3696
* CVE-2021-3697
* CVE-2022-28733
* CVE-2022-28734
* CVE-2022-28735
* CVE-2022-28736
* CVE-2022-28737

### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
-------------------------------------------------------------------------------

Not applicable.
This is our first shim review submission for PuzzleOS, complete with new
vendor certificates that have not previously signed any second stage
bootloader or EFI binaries.

-------------------------------------------------------------------------------
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?

-------------------------------------------------------------------------------

Yes, it contains the first two commits mentioned above.
Our kernel does not include kgdb support, so the third commit is not applicable.

-------------------------------------------------------------------------------
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
-------------------------------------------------------------------------------

Our shim consists of three vendor certificates:
- a "production" certificate
- a "management" certificate
- a "limited" certificate

The PEM formatted, self-signed certificates (CA bit is set to False) are
available in the "config/certs" directory. No hashes are present in
the shim's allow-list.

The different vendor certificates, and the associated signed boot chain, are
used in conjunction with the TPM's PCR7 and TPM Extended Authorization policies
to control access to TPM based secrets such that only authorized OS kernels are
allowed to access secrets stored in the TPM's NVRAM. Each certificate represents
an authorized access to specific secrets.

Thus, we must be able to distinguish kernels signed with each of the keys by
their pcr7 value. The pcr7 value is used to build the TPM EA Policy for our 
efi binaries (kernel+initrd+cmdline) that are signed with these 3 keys. 
We tested with a parentCA only in either the VENDOR_CERT_FILE or
VENDOR_DB_FILE, and shim uses that to extend pcr7. We are then unable
to use the pcr7 value to distinguish our kernels nor apply our
TPM EA Policies appropriately.

-------------------------------------------------------------------------------
### If you are re-using a previously used (CA) certificate, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs to vendor_dbx in shim in order to prevent GRUB2 from being able to chainload those older GRUB2 binaries. If you are changing to a new (CA) certificate, this does not apply.
### Please describe your strategy.
-------------------------------------------------------------------------------

This is our first shim review submission for PuzzleOs, complete with new
vendor certificates that have not previously signed any second stage loaders
or EFI binaries.

-------------------------------------------------------------------------------
### What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as closely as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
### If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and what the differences would be.
-------------------------------------------------------------------------------

All package versions are displayed in the build log. The included Makefile
and Dockerfile are the same as what we use to build our shim. A new shim
can be built using the `make build` command.

-------------------------------------------------------------------------------
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.

-------------------------------------------------------------------------------

The build log and relevant shim build artifacts can be found in
the "artifacts.20220706123022" directory.

-------------------------------------------------------------------------------
### What changes were made since your SHIM was last signed?
-------------------------------------------------------------------------------

This is our first shim review submission for PuzzleOS.

-------------------------------------------------------------------------------
### What is the SHA256 hash of your final SHIM binary?
-------------------------------------------------------------------------------
[your text here]
c44d3bff9c43a24b443a8ba48cf8963441291b48e44c6e427d628e8a05a64e46  shimx64.efi

-------------------------------------------------------------------------------
### How do you manage and protect the keys used in your SHIM?
-------------------------------------------------------------------------------

Keys are managed and stored in Cisco's corporate key management system that
is an HSM. Access is tightly controlled and operations are restricted to
authorized individuals.

-------------------------------------------------------------------------------
### Do you use EV certificates as embedded certificates in the SHIM?
-------------------------------------------------------------------------------

No.

-------------------------------------------------------------------------------
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( grub2, fwupd, fwupdate, shim + all child shim binaries )?
### Please provide exact SBAT entries for all SBAT binaries you are booting or planning to boot directly through shim.
### Where your code is only slightly modified from an upstream vendor's, please also preserve their SBAT entries to simplify revocation.
-------------------------------------------------------------------------------

Our shim build uses the SBAT information below:

sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,1,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.puzzleos,1,PuzzleOS,shim,15.6-202207-1,https://github.com/puzzleos

We boot Linux Kernels directly from shim using stubby.
Our kernel EFI binaries contain:

sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
stubby.puzzleos,1,PuzzleOS,stubby,1,https://github.com/puzzleos/stubby
linux.puzzleos,1,PuzzleOS,linux,1,NOURL

-------------------------------------------------------------------------------
### Which modules are built into your signed grub image?
-------------------------------------------------------------------------------

We do not use a signed grub image.

-------------------------------------------------------------------------------
### What is the origin and full version number of your bootloader (GRUB or other)?
-------------------------------------------------------------------------------

We do not use GRUB2 as a second stage loader. Our Linux kernel, initramfs, and
kernel command line are bundled into a single EFI binary such that the PE/COFF
signature protects all of those components. We use a small EFI stub based on the
systemd-boot stub, to do this and we have augmented it to add support for a
SBAT section. The "stubby" uefi bootloader source is located at
https://github.com/puzzleos/stubby.

Our shim will boot the Linux kernel.

-------------------------------------------------------------------------------
### If your SHIM launches any other components, please provide further details on what is launched.
-------------------------------------------------------------------------------

Our shim launches the Linux Kernel.

-------------------------------------------------------------------------------
### If your GRUB2 launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
-------------------------------------------------------------------------------

Not applicable. We do not use GRUB2 as stated above.

-------------------------------------------------------------------------------
### How do the launched components prevent execution of unauthenticated code?
-------------------------------------------------------------------------------

We rely on existing Linux kernel mechanisms to prevent the execution of
unauthenticated code.

-------------------------------------------------------------------------------
### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?
-------------------------------------------------------------------------------

No, we do not use our shim to load any additional bootloaders.

-------------------------------------------------------------------------------
### What kernel are you using? Which patches does it includes to enforce Secure Boot?
-------------------------------------------------------------------------------

We plan to sign kernel 5.10.124 and later..

-------------------------------------------------------------------------------
### Add any additional information you think we may need to validate this shim.
-------------------------------------------------------------------------------

None.
