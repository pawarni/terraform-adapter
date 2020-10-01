resource "vra_deployment" "this" {
  name        = "Terraform Deployment"
  description = "Deployed from vRA provider for Terraform."

  blueprint_id      = vra_blueprint.this.id
  project_id        = vra_project.this.id

  inputs = {
    Flavor = "small"
    Image  = "ubuntu-bionic"
  }
}