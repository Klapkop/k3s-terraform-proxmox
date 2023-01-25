terraform {
  cloud {
    organization = "berglucht"

    workspaces {
      name = "k3s-rancher"
    }
  }
}