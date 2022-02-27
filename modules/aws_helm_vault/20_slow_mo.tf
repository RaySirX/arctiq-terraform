resource "null_resource" "previous" {}

resource "time_sleep" "wait_20_seconds" {
  depends_on = [null_resource.previous]

  destroy_duration = "20s"
}

# This resource will create (potentially immediately) after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_20_seconds]
}
