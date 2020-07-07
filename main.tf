provider "azuredevops" {
  version = ">= 0.0.1"
}

resource "azuredevops_project" "test" {
  project_name = "test-project"
}

resource "azuredevops_git_repository" "test" {
  project_id = azuredevops_project.test.id
  name       = "test-repo"
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_variable_group" "test" {
  project_id   = azuredevops_project.test.id
  name         = "test-vg"
  allow_access = true

  variable {
    name  = "example_var_name"
    value = "example_var_value"
  }
}
