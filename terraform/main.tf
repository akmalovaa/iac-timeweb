# Варианты конфигурации сервера фиксированная или произвольная 
# С помощью twc_presets можно выбрать фиксированную конфигурацию
# Полный список можно проверить при создании сервера в web-gui Timeweb или тут https://api.timeweb.cloud/api/v1/presets/servers
# Удобно фильтровать по цене (Указал от 150 рублей до 200 рублей)
# Выбор расположения ru-1 Москва, pl-1 Польша, kz-1 Казахстан(Астана)
data "twc_presets" "main-preset" {
  location = "ru-1"
  # Price RUB per month
  price_filter {
    from = 150
    to = 200
  }
#   disk_type = "ssd"
#   disk = 15360
#   cpu = 1
#   ram = 1024
}

# В timeweb есть возможность создать VPS с уже установленным docker (цена и тарифы такие же)
# Доступные software можно посмотреть в web-gui Timeweb или по API https://api.timeweb.cloud/api/v1/software/servers
data "twc_software" "software" {
  name = "Docker"
  os {
    name = "ubuntu"
    version = "22.04"
  }
}

# Получить список проектов
data "twc_projects" "terraform-project" {
  name = "homelab"
}

# Получить ssh-key
data "twc_ssh_keys" "ssh-key" {
  name = "monitoring"
}

# Создать сервер
resource "twc_server" "monitoring-server" {
  project_id = data.twc_projects.terraform-project.id
  name = "monitoring"
  os_id = data.twc_software.software.os[0].id
  software_id = data.twc_software.software.id
  ssh_keys_ids = [data.twc_ssh_keys.ssh-key.id]

  preset_id = data.twc_presets.main-preset.id
}

# Создать inventory файл для Ansible
resource "local_file" "ansible_hosts" {
  content = templatefile("${path.module}/templates/hosts.yaml",
    {
      ip_address = twc_server.monitoring-server.main_ipv4
    }
  )
  filename = "../ansible/hosts.yaml"
}

# Сохранить название и id сервера для импорта при потере состояния
resource "local_file" "terraform_mini_state" {
  content = templatefile("${path.module}/templates/import.sh",
    {
      name = twc_server.monitoring-server.name
      id = twc_server.monitoring-server.id
    }
  )
  filename = "import_server.sh"
}