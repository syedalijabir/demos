locals {
  system_key = join("-", [
    var.system,
    var.environment
    ]
  )
}
