variable "TWC_TOKEN" {
  description = "timeweb API token, https://timeweb.cloud/my/api-keys"
  type = string
  sensitive = true
}

# Сохранить API token в файл - env.auto.tfvars или добавить в переменные окружения
# TF_VAR_TWC_TOKEN= "eXamPlEt0kEn1234710279340-91200-9fd-w8921jd12."
