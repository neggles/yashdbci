group "default" {
  targets = ["yagpdb"]
}

variable "IMAGE_REGISTRY" {
  default = "ghcr.io"
}

variable "REPO_NAME" {
  default = "neggles/yagpdbci"
}

variable "IMAGE_NAME" {
  default = "yagpdb"
}

variable "YAGPDB_REPO" {
  default = "https://github.com/botlabs-gg/yagpdb.git"
}

variable "YAGPDB_REF" {
  default = "master"
}

# docker-metadata-action will populate this in GitHub Actions
target "docker-metadata-action" {}

# tags go in here so we can let docker-metadata-action override in GitHub Actions
target "common" {
  dockerfile = "Dockerfile"
  tags = [
    "${IMAGE_REGISTRY}/${REPO_NAME}/${IMAGE_NAME}:local"
  ]
  platforms = ["linux/amd64"]
}

target "yagpdb" {
  inherits = ["common", "docker-metadata-action"]
  context  = "."
  args = {
    CGO_ENABLED = "0"
    GOOS        = "linux"
    YAGPDB_REPO = "${YAGPDB_REPO}"
    YAGPDB_REF  = "${YAGPDB_REF}"
  }
}
