# terraform-pester-devcontainer-example

This is an example terraform project with Pester testing and a devcontainer.

## Azure Devops pipelines

- [Classic pipeline](.azdo/classic-pipeline.yml)
- [Pipeline utilizing the devcontainer](.azdo/devcontainer-pipeline.yml)
- [Pipeline utilizing the devcontainer with caching](.azdo/devcontainer-caching-pipeline.yml)

## Execute commands in devcontainer locally

```ps
    docker run `
        -e AZURE_DEVOPS_EXT_PAT=$env:AZDO_PERSONAL_ACCESS_TOKEN `
        -e AZDO_PERSONAL_ACCESS_TOKEN=$env:AZDO_PERSONAL_ACCESS_TOKEN `
        -e AZDO_ORG_SERVICE_URL=$env:AZDO_ORG_SERVICE_URL `
        --entrypoint /opt/microsoft/powershell/7/pwsh `
        -v <host/source/directory>:/src `
        --workdir /src `
        devcontainer `
        -c Invoke-Pester
```
