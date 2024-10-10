This Docker Compose configuration sets up two services:

1. `edge-intune`: This service installs the Microsoft Edge browser and the Intune Portal on an Ubuntu 22.04 base image. It performs the following steps:
   - Updates the package lists
   - Installs required dependencies
   - Adds the Microsoft package repository
   - Installs the Microsoft Edge browser
   - Upgrades the installed packages
   - Installs the Intune Portal
   - Runs the container in the foreground to keep it alive

2. `edge-intune-24`: This service sets up an Ubuntu 24.04 base image and performs the following steps:
   - Configures the Ubuntu package sources
   - Installs required dependencies
   - Adds the Microsoft package repository
   - Installs the Intune Portal
   - Modifies the Java Home environment variable in the Microsoft Identity Broker and Device Broker services
   - Installs a dummy default-jre package to satisfy a dependency
   - Runs the container in the foreground to keep it alive

Both services are marked as `privileged` to allow them to perform the necessary system-level operations.
