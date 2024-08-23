provider "kubernetes" {
  config_path = "~/.kube/config"
}

# resource "kubernetes_namespace" "example" {
#   metadata {
#     name = "terraform-test"
#   }
# }

resource "kubernetes_deployment" "hello_world" {
  metadata {
    name      = "hello-world"
    namespace = "terraform-test"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "hello-world"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-world"
        }
      }

      spec {
        container {
          name  = "hello-world"
          image = "python:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello_world" {
  metadata {
    name      = "hello-world"
    namespace = "terraform-test"
  }

  spec {
    selector = {
      app = "hello-world"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
