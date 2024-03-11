variable "twc_token" {
  description = "timeweb API token, https://timeweb.cloud/my/api-keys"
  type = string
  sensitive = true
}

# Сохранить API token в файл - env.auto.tfvars
# twc_token = "eyJhbGcsaohjdshoaohgasgashod..."
