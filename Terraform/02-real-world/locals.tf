locals {
  tags = {
    tool        = "Terraform"
    environment = "${var.env}"
    demo        = 3
  }
}
