# IaC-timeweb

Репозиторий для экспериментов с IaC Timeweb

## Описание

### Сервер для мониторинга

В качестве примера буду использовать сервис [Gatus](https://github.com/TwiN/gatus), который в отличии от uptime-kuma позволяет гибко настроить конфигурацию в `.yaml` формате

Дополнительно в нагрузку подниму сервисы **Prometheus** + **Grafana**, и все это удобнее запустить в `docker-compose`

- **Terraform** - создание VPS
- **Ansible** - установка софта, передача конфигурациионных файлов и запуск сервисов



## Подготовка

### Установить

#### [Terraform](https://developer.hashicorp.com/terraform/install)
Можно использовать локально или в docker с подготовленным образом

#### [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
Можно использовать локально или в docker с подготовленным образом

#### [Taskfile](https://taskfile.dev/) (не обязательно)
Удобное использование заготовленных команд

#### [Docker](https://docs.docker.com/engine/install) (не обязательно)
Удобнее использовать Docker c уже подготовленным окружением и установленными:
- Ansible
- Terraform
- Taskfile

На локальной машине можно ничего даже не устанавливать кроме docker, но все равно рекомендовал бы Taskfile поставить

> [!WARNING]  
> При локальной сборке Dockerfile возможно проблемы из-за ограничений доступа hashicorp (использовать VPN)

Или использовать готовый image: `docker pull iactools:1.0.0`



### Настройка

#### Учетная запись **timeweb**
Войти или Зарегаться [реф.ссылка](https://timeweb.cloud/r/cp14436)

#### Настройка проекта
В качестве названия проекта используется `homelab` нужно [создать](https://timeweb.cloud/my/projects) такой же или

поменять на свой проект в настройках `terraform/main.tf`
```json
data "twc_projects" "terraform-project" {
  name = "homelab"
}
```


#### SSH key
Создать новые или использовать уже сгенерированные ранее ключи
- **private_key:** Используется для удобства подключения и работы Ansible 
- **public_key:** Добавляется на сервер при его создании

Необходимо свой **public_key** добавить в [панель управления](https://timeweb.cloud/my/sshkeys) назвал `monitoring`

Используется в `terraform/main.tf`
```json
data "twc_ssh_keys" "ssh-key" {
  name = "monitoring"
}
```

**private_key** - для ansible использовать в > `ansible/ssh/id_rsa`


#### API keys

Создать здесь https://timeweb.cloud/my/api-keys

Использовать в `terraform/env.auto.tfvars`
```toml
twc_token = "eyJhbGcsaohjdshoaohgasgashod..."
```

#### Настройка сервера



#### Настройка сервисов

Основные настройки в файле `.env`

Тонкая настройка сервисов в `ansible/docker/` 


##### terraform init
> [!WARNING]
> Для скачивания `local`  нужен доступ `registry.terraform.io/hashicorp/local` (использовать VPN)


terraform plan

terraform apply -auto-approve

terraform destroy -auto-approve


---

```
curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $twc_token" \
  "https://api.timeweb.cloud/api/v1/software/servers"
```

https://timeweb.cloud/my/ideas/13575