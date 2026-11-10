# Planejamento do Projeto — DevOps Fase 1

## Descrição
API REST de Catálogo de Séries desenvolvida com Node.js e Express para consulta e cadastro de séries.

## Objetivos
- Desenvolver uma API REST funcional.
- Versionar o código no GitHub.
- Automatizar testes por meio do GitHub Actions.
- Definir a infraestrutura como código com Terraform.

## Requisitos funcionais
- RF01: Consultar o estado de funcionamento da API.
- RF02: Listar as séries cadastradas.
- RF03: Consultar uma série pelo identificador.
- RF04: Cadastrar novas séries.
- RF05: Validar os dados recebidos no cadastro.

## Requisitos não funcionais
- RNF01: Utilizar Node.js e Express.
- RNF02: Manter o código versionado no GitHub.
- RNF03: Executar testes automatizados no pipeline de CI.
- RNF04: Definir infraestrutura reproduzível com Terraform.
- RNF05: Documentar a execução e a validação do projeto.

## Planejamento da integração contínua
Ferramenta: GitHub Actions.

Gatilhos: push e pull_request na branch main.

Etapas:
1. Baixar o código do repositório.
2. Configurar Node.js.
3. Instalar dependências.
4. Executar testes automatizados.
5. Configurar Terraform.
6. Verificar formatação dos arquivos Terraform.
7. Inicializar Terraform sem backend remoto.
8. Validar a configuração da infraestrutura.

## Especificação da infraestrutura
Provedor de nuvem: AWS.
Ferramenta de IaC: Terraform.
Servidor planejado: instância EC2 com Ubuntu.
Rede: VPC padrão e sub-rede disponível.
Segurança: grupo de segurança com regras de acesso.
Aplicação: API Node.js na porta 3000.
Inicialização: instalação automatizada por user_data.

## Testes
Cinco testes automatizados:
1. Verificar funcionamento da API.
2. Listar séries cadastradas.
3. Retornar 404 para série inexistente.
4. Cadastrar série válida.
5. Rejeitar dados inválidos.

## Resultados da Fase 1
- API executada e verificada localmente.
- Cinco testes automatizados aprovados.
- Repositório publicado no GitHub.
- Pipeline GitHub Actions executado com sucesso.
- Configuração Terraform validada.
- Infraestrutura AWS definida, mas não provisionada.

## Repositório
https://github.com/gildasio91/devops-fase1-catalogo-series
