terraform {
  cloud {
    organization = "berglucht"

    workspaces {
      name = "sprint-staging"
    }
  }
}