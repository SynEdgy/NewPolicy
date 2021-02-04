# Quick Guest Config Package test

I've setup a quick repo to test Guest Config Packaging and execution.
- on Windows/Linux
- with MOF/Class resources

This repo has 2 branches:
- `main`: a Module NewPolicy, with a Class based DSC Resource, used in a NewPolicy package
- `mofresource`: same module with a MOF DSC resource instead, used in a new Policy package. Should be the same except the DSC resource being class based instead of MOF based.

This project has a `run.ps1` file that executes the different steps:
1. compile the MOF from the configuration.
2. Package the GuestConfiguration Package
3. if on Windows and running elevated, use `Test-GuestConfigurationPackage` (for now, windows only).

# Result

in short:

| Resource type | OS | PS version | Result |
| ---------|-----|------------|-------|
| MOF | Windows | 5.1 | Works |
| MOF | Windows | 7.1.1 | Works |
| MOF | Ubuntu | 7.1.1 | Compiles MOF, Packages Policy, fails to test (as expected)  |
| CLASS | Windows | 5.1 | Works |
| CLASS | Windows | 7.1.1 | Fails to Compile (hangs and crash PS after 2min) |
| CLASS | Ubuntu | 7.1.1 | Fails to compile MOF with: `WARNING: Embedded resources are not support on Linux or macOS.  Please see https://aka.ms/PSCoreDSC for more details.` |