
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
FROM debian:buster-slim

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Versions
ARG TERRAFORM_VERSION=0.12.25
ARG TFLINT_VERSION=0.15.3

# Folder names
ARG TERRAFORM_PROVIDER_AZUREDEVOPS_NAME=terraform-provider-azuredevops
ARG TERRAFORM_SHELL_PROVIDER_NAME=terraform-provider-shell

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1 \
    # Verify git, process tools, lsb-release (common in install instructions for CLIs), unzip, curl, wget installed
    && apt-get -y install git procps lsb-release unzip curl wget \
    # Install Editor
    && apt-get install vim -y \
    # Install Terraform
    && mkdir -p /tmp/docker-downloads \
    && curl -sSL -o /tmp/docker-downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip /tmp/docker-downloads/terraform.zip \
    && mv terraform /usr/local/bin \
    # Install tflint
    && curl -sSL -o /tmp/docker-downloads/tflint.zip https://github.com/wata727/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip \
    && unzip /tmp/docker-downloads/tflint.zip \
    && mv tflint /usr/local/bin \
    # Clean up downloaded files
    && cd ~ \ 
    && rm -rf /tmp/docker-downloads \
    # Install AzCLI
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    # Install AzDO CLI
    && az extension add --name azure-devops \
    # Install PowerShell 7
    && wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Bash customization
RUN \
    ## Git command prompt
    git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1 \
    && echo "if [ -f \"$HOME/.bash-git-prompt/gitprompt.sh\" ]; then GIT_PROMPT_ONLY_IN_REPO=1 && source $HOME/.bash-git-prompt/gitprompt.sh; fi" >> "/root/.bashrc" \
    ## Add alias
    && echo "alias tf=terraform" >> "/root/.bashrc" \
    && echo "alias powershell=pwsh" >> "/root/.bashrc"

# Powershell customization
RUN \
    # Set Powershell to use TLS 1.2
    pwsh -c "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12" \
    # Install Pester
    && pwsh -c "Install-Module -Name Pester -Force -RequiredVersion 4.10.1" \
    ## Create PS profile
    && pwsh -c 'New-Item -Path $profile -ItemType File -Force' \
    ## Add aliases
    && pwsh -c "Add-Content -Path \$profile -Value 'New-Alias \"tf\" \"terraform\"'" \
    && pwsh -c "Add-Content -Path \$profile -Value 'New-Alias \"powershell\" \"pwsh\"'" 

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog