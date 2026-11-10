# API de Catálogo de Séries

Projeto acadêmico da disciplina DevOps na Prática - Fase 1.

## Objetivo
Disponibilizar uma API REST para consultar e cadastrar séries, automatizar testes com GitHub Actions e descrever a infraestrutura de hospedagem com Terraform na AWS.

## Tecnologias
- Node.js 22 e Express
- Node Test Runner (`node:test`)
- GitHub Actions
- Terraform e AWS EC2

## Executar localmente
Requisitos: Node.js 20 ou superior.

```bash
npm install
npm test
npm start
```

A API ficará disponível em `http://localhost:3000`.

## Endpoints
- `GET /health`: verifica se a API está funcionando.
- `GET /series`: lista séries.
- `GET /series/:id`: consulta uma série pelo identificador.
- `POST /series`: cadastra uma série.

Exemplo de corpo para `POST /series`:

```json
{
  "title": "Dark",
  "genre": "Suspense",
  "seasons": 3
}
```

## Integração contínua
O workflow `.github/workflows/ci.yml` é executado em todo `push` e `pull_request` para a branch `main`. Ele instala dependências, executa os testes automatizados e valida a formatação e configuração do Terraform.

## Infraestrutura como Código
A pasta `terraform/` contém os arquivos para provisionar uma instância EC2 Ubuntu, grupo de segurança e regras de acesso. A aplicação é instalada na inicialização da instância por meio de `user_data`.

### Validar Terraform localmente
Com Terraform instalado:

```bash
cd terraform
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

### Provisionamento real (opcional)
Não execute `terraform apply` sem revisar os custos e configurar credenciais AWS. Antes de aplicar:
1. Configure credenciais AWS localmente com `aws configure`.
2. Copie `terraform.tfvars.example` para `terraform.tfvars`.
3. Informe a URL HTTPS do repositório público e seu IP público em CIDR (`/32`) no campo `admin_cidr`.
4. Execute `terraform plan` e revise os recursos.
5. Só então, se desejar e tiver autorização, execute `terraform apply`.

Para remover recursos criados: `terraform destroy`.

**Atenção:** a instância EC2 e o tráfego de dados podem gerar cobranças. O grupo de segurança libera a porta 3000 para a internet; use essa configuração apenas para demonstração e avalie restringi-la em um ambiente real.
