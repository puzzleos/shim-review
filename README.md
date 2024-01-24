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

Check the docs directory in this repo for guidance on submission and
getting your shim signed.

Here's the template:

*******************************************************************************
### What organization or people are asking to have this signed?
*******************************************************************************

Cisco Systems, Inc.

*******************************************************************************
### What product or service is this for?
*******************************************************************************

PuzzleOS, a Linux based appliance OS used in Cisco products.

*******************************************************************************
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
*******************************************************************************

The OS is designed to run on any platform that supports UEFI Secure Boot
and the easiest way to support the largest number of systems is to have
a shim bootloader signed by Microsoft.

*******************************************************************************
### Why are you unable to reuse shim from another distro that is already signed?
*******************************************************************************

Most distros' shim load GRUB2 signed with their key. 
Our shim must load our UKI signed with a Cisco key.
Thus, we cannot reuse a shim from a distro to boot our UKI.
We require a shim that includes our Cisco credentials in the vendordb
to load and verify our UKI.

*******************************************************************************
### Who is the primary contact for security updates, etc.?
The security contacts need to be verified before the shim can be accepted. For subsequent requests, contact verification is only necessary if the security contacts or their PGP keys have changed since the last successful verification.

An authorized reviewer will initiate contact verification by sending each security contact a PGP-encrypted email containing random words.
You will be asked to post the contents of these mails in your `shim-review` issue to prove ownership of the email addresses and PGP keys.
*******************************************************************************

- Name:
- Position:
- Email address:
- PGP key fingerprint:

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Who is the secondary contact for security updates, etc.?
*******************************************************************************

- Name:
- Position:
- Email address:
- PGP key fingerprint:

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Were these binaries created from the 15.8 shim release tar?
Please create your shim binaries starting with the 15.8 shim release tar file: https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.8 and contains the appropriate gnu-efi source.

*******************************************************************************

Our source is the 15.8 shim release tar file.

*******************************************************************************
### URL for a repo that contains the exact code which was built to get this binary:
*******************************************************************************

https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2

*******************************************************************************
### What patches are being applied and why:
*******************************************************************************

None.

*******************************************************************************
### If shim is loading GRUB2 bootloader what exact implementation of Secureboot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
*******************************************************************************

We do not use GRUB2 as a second stage loader. We use a Unified Kernel Image
(UKI), consisting of our Linux kernel, initramfs, and kernel command line.
The UKI is a single EFI binary such that the PE/COFF signature protects
all of the components. We use a small EFI stub based on the systemd-boot stub,
to do this and we have augmented it to add support for a SBAT section.
The "stubby" uefi bootloader source is located at
https://github.com/puzzleos/stubby.

*******************************************************************************
### If shim is loading GRUB2 bootloader and your previously released shim booted a version of GRUB2 affected by any of the CVEs in the July 2020, the March 2021, the June 7th 2022, the November 15th 2022, or 3rd of October 2023 GRUB2 CVE list, have fixes for all these CVEs been applied?

* 2020 July - BootHole
  * Details: https://lists.gnu.org/archive/html/grub-devel/2020-07/msg00034.html
  * CVE-2020-10713
  * CVE-2020-14308
  * CVE-2020-14309
  * CVE-2020-14310
  * CVE-2020-14311
  * CVE-2020-15705
  * CVE-2020-15706
  * CVE-2020-15707
* March 2021
  * Details: https://lists.gnu.org/archive/html/grub-devel/2021-03/msg00007.html
  * CVE-2020-14372
  * CVE-2020-25632
  * CVE-2020-25647
  * CVE-2020-27749
  * CVE-2020-27779
  * CVE-2021-3418 (if you are shipping the shim_lock module)
  * CVE-2021-20225
  * CVE-2021-20233
* June 2022
  * Details: https://lists.gnu.org/archive/html/grub-devel/2022-06/msg00035.html, SBAT increase to 2
  * CVE-2021-3695
  * CVE-2021-3696
  * CVE-2021-3697
  * CVE-2022-28733
  * CVE-2022-28734
  * CVE-2022-28735
  * CVE-2022-28736
  * CVE-2022-28737
* November 2022
  * Details: https://lists.gnu.org/archive/html/grub-devel/2022-11/msg00059.html, SBAT increase to 3
  * CVE-2022-2601
  * CVE-2022-3775
* October 2023 - NTFS vulnerabilities
  * Details: https://lists.gnu.org/archive/html/grub-devel/2023-10/msg00028.html, SBAT increase to 4
  * CVE-2023-4693
  * CVE-2023-4692
*******************************************************************************

Not Applicable.
This release and the prior release of our shim boot a UKI.

*******************************************************************************
### If these fixes have been applied, is the upstream global SBAT generation in your GRUB2 binary set to 4?
The entry should look similar to: `grub,4,Free Software Foundation,grub,GRUB_UPSTREAM_VERSION,https://www.gnu.org/software/grub/`
*******************************************************************************

Not applicable.
Our shim boots a UKI and not grub.

*******************************************************************************
### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
*******************************************************************************
[your text here]

*******************************************************************************
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
*******************************************************************************

Yes, it contains the first two commits mentioned above.
Our kernel does not include kgdb support, so the third commit is not applicable.

*******************************************************************************
### Do you build your signed kernel with additional local patches? What do they do?
*******************************************************************************

Yes, we have included a very small set of local patches, with minor changes
to accomodate the Cisco appliances that use PuzzleOS.

*******************************************************************************
### Do you use an ephemeral key for signing kernel modules?
### If not, please describe how you ensure that one kernel build does not load modules built for another kernel.
*******************************************************************************

Yes.

*******************************************************************************
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
*******************************************************************************

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
efi binaries (UKI:kernel+initrd+cmdline) that are signed with these 3 keys.
We tested with a parentCA only in either the VENDOR_CERT_FILE or
VENDOR_DB_FILE, and shim uses that to extend pcr7. We are then unable
to use the pcr7 value to distinguish our kernels nor apply our
TPM EA Policies appropriately.

*******************************************************************************
### If you are re-using a previously used (CA) certificate, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs to vendor_dbx in shim in order to prevent GRUB2 from being able to chainload those older GRUB2 binaries. If you are changing to a new (CA) certificate, this does not apply.
### Please describe your strategy.
*******************************************************************************

We are re-using previous certificates, but our shim does not load GRUB2.
It loads a signed UKI. Thus this is not applicable.

*******************************************************************************
### What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as closely as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
### If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and what the differences would be.
*******************************************************************************

All package versions are displayed in the build log. The included Makefile
and Dockerfile are the same as what we use to build our shim. A new shim
can be built using the `make build` command.

*******************************************************************************
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
*******************************************************************************

The build log and relevant shim build artifacts can be found in
the "artifacts.20240201113138" directory.

*******************************************************************************
### What changes were made since your SHIM was last signed?
*******************************************************************************

Update shim from 15.6 to 15.8.

*******************************************************************************
### What is the SHA256 hash of your final SHIM binary?
*******************************************************************************
[your text here]

*******************************************************************************
### How do you manage and protect the keys used in your SHIM?
*******************************************************************************

Keys are managed and stored in Cisco's corporate key management system that
is an HSM. Access is tightly controlled and operations are restricted to
authorized individuals.

*******************************************************************************
### Do you use EV certificates as embedded certificates in the SHIM?
*******************************************************************************

No.

*******************************************************************************
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( GRUB2, fwupd, fwupdate, shim + all child shim binaries )?
### Please provide exact SBAT entries for all SBAT binaries you are booting or planning to boot directly through shim.
### Where your code is only slightly modified from an upstream vendor's, please also preserve their SBAT entries to simplify revocation.
If you are using a downstream implementation of GRUB2 (e.g. from Fedora or Debian), please
preserve the SBAT entry from those distributions and only append your own.
More information on how SBAT works can be found [here](https://github.com/rhboot/shim/blob/main/SBAT.md).
*******************************************************************************
[your text here]

*******************************************************************************
### Which modules are built into your signed GRUB2 image?
*******************************************************************************

We do not use a signed grub image.

*******************************************************************************
### What is the origin and full version number of your bootloader (GRUB2 or other)?
*******************************************************************************
[your text here]

*******************************************************************************
### If your SHIM launches any other components, please provide further details on what is launched.
*******************************************************************************

Our shim launches our signed UKI.

*******************************************************************************
### If your GRUB2 launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
*******************************************************************************

Not applicable. We do not use GRUB2 as stated above.

*******************************************************************************
### How do the launched components prevent execution of unauthenticated code?
*******************************************************************************

We rely on existing Linux kernel mechanisms to prevent the execution of
unauthenticated code.

*******************************************************************************
### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB2)?
*******************************************************************************

No, we do not use our shim to load any additional bootloaders.

*******************************************************************************
### What kernel are you using? Which patches does it includes to enforce Secure Boot?
*******************************************************************************
[your text here]

*******************************************************************************
### Add any additional information you think we may need to validate this shim.
*******************************************************************************
[your text here]
