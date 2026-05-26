# Terraform + Ansible — Azure VM Homelab

Projeto de estudo DevOps que provisiona uma máquina virtual Linux na Azure com Terraform e a configura automaticamente com Ansible.

## Arquitetura

```
Azure
└── Resource Group (rg-homelab-devops)
    ├── Virtual Network (10.0.0.0/16)
    │   └── Subnet (10.0.2.0/24)
    ├── Public IP (Static)
    ├── Network Security Group
    │   ├── Regra: SSH (porta 22)
    │   └── Regra: HTTP (porta 80)
    ├── Network Interface
    └── VM Linux Ubuntu 22.04 LTS (Standard_D2s_v3)
```

Após o provisionamento, o Ansible configura a VM com:

| Role | O que faz |
|---|---|
| `common` | Atualiza pacotes e instala ferramentas essenciais (git, curl, wget, htop, unzip) |
| `docker` | Instala Docker CE e adiciona o usuário ao grupo docker |
| `nginx` | Instala Nginx e cria uma página de boas-vindas |

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/) >= 2.12
- [Azure CLI](https://learn.microsoft.com/pt-br/cli/azure/install-azure-cli) autenticado (`az login`)
- Par de chaves SSH gerado em `~/.ssh/id_rsa` e `~/.ssh/id_rsa.pub`

## Como usar

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/Terraform-Azure.git
cd Terraform-Azure
```

### 2. Configure as variáveis do Terraform

```bash
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seus valores
```

### 3. Provisione a infraestrutura na Azure

```bash
terraform init
terraform plan
terraform apply
```

Ao final, o output exibirá o IP público da VM.

### 4. Configure o inventário do Ansible

```bash
cp ansible/inventory.ini.example ansible/inventory.ini
# Substitua <IP_PUBLICO_DA_VM> pelo IP exibido no output do Terraform
```

### 5. Execute o playbook Ansible

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml
```

### 6. Destrua os recursos ao terminar

```bash
cd ..
terraform destroy
```

> ⚠️ Lembre-se de destruir os recursos para evitar cobranças inesperadas na Azure.

## Estrutura do projeto

```
.
├── main.tf                         # Recursos Azure (VNet, NSG, VM, etc.)
├── variables.tf                    # Definição de variáveis
├── outputs.tf                      # Outputs (IP público, ID da VM)
├── terraform.tfvars.example        # Template de variáveis (sem dados reais)
├── .gitignore                      # Exclui tfstate, tfvars, inventory.ini
└── ansible/
    ├── playbook.yml                # Playbook principal
    ├── inventory.ini.example       # Template de inventário
    ├── group_vars/
    │   └── all.yml                 # Variáveis globais do Ansible
    └── roles/
        ├── common/tasks/main.yml   # Pacotes essenciais
        ├── docker/tasks/main.yml   # Instalação do Docker
        └── nginx/
            ├── tasks/main.yml      # Instalação e configuração do Nginx
            └── handlers/main.yml   # Handler para restart do Nginx
```

## Tecnologias

- **Terraform** — Infrastructure as Code (IaC) para provisionar recursos na Azure
- **Ansible** — Configuration Management para configurar a VM via roles
- **Azure** — Cloud provider (azurerm provider ~> 4.0)
- **Ubuntu 22.04 LTS** — Sistema operacional da VM
- **Docker** + **Nginx** — Serviços configurados via Ansible

## Segurança

- Chaves SSH e IPs reais **nunca** são commitados (ver `.gitignore`)
- O `terraform.tfstate` é ignorado pelo Git — em produção, use [remote state](https://developer.hashicorp.com/terraform/language/state/remote) (Azure Storage Account ou Terraform Cloud)
- O NSG libera apenas as portas 22 (SSH) e 80 (HTTP)
