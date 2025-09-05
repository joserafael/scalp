## Requisitos Funcionais

Vamos desenvolver um sistema especializado em operações de scalp trading com criptomoedas.

O sistema deve disponibilizar um formulário que permita:

- Selecionar o tipo de operação: compra ou venda
- Escolher a criptomoeda desejada
- Informar o valor total da operação
- Informar o preço unitário da criptomoeda no momento da operação
- Informar a quantidade de tokens negociados

Para cada par de compra e venda, o sistema deve calcular o lucro da operação:

1. Exemplo: Comprei 100 tokens a R$ 10,00
2. Vendi 100 tokens a R$ 12,00
3. Lucro obtido: R$ 2,00

O cálculo de lucro só será realizado se o resultado for positivo. Caso contrário, a compra ou venda permanecerá em aberto:

- Exemplo: Comprei 100 tokens a R$ 10,00 (aguardando venda)
- Exemplo: Vendi 100 tokens a R$ 12,00 (aguardando compra)
- Exemplo: Comprei 100 tokens a R$ 10,00 e vendi 100 tokens a R$ 9,00 (prejuízo, operação permanece em aberto)

Além disso, o sistema deve sempre priorizar o menor lucro possível ao realizar os matches.
Se uma nova operação futura permitir um pareamento que resulte em um lucro menor, o sistema deve desfazer o match
anterior, liberar as operações envolvidas e refazer o pareamento com o novo menor lucro.
Dessa forma, o usuário sempre terá uma visão das operações em aberto que possibilitam maiores lucros futuros, mantendo
o controle do mínimo trade necessário. Exemplo:

1. Comprei 100 tokens a R$ 10,00
2. Vendi 100 tokens a R$ 12,00
3. Lucro de R$ 2,00 (match realizado)

Se posteriormente houver uma venda de 100 tokens a R$ 11,00, o sistema deve desfazer o match anterior e refazê-lo com
essa nova venda, resultando em um lucro menor de R$ 1,00, deixando a venda de 100 tokens a R$ 12,00 em aberto.

O mesmo princípio se aplica para compras: se uma nova compra de 100 tokens a R$ 11,00 permitir um lucro menor, o
sistema deve liberar a compra anterior de R$ 10,00 e refazer o match.

## Requisitos Não Funcionais

1. O sistema deve fazer os matches de uma forma que não interfira o usuário a continuar usando o sistema.
2. As ações do usuário não devem exigir recarregamento completo da página.
3. O backend deve ser implementado utilizando Ruby on Rails.
4. O sistema deve conter testes automatizados.

## Instruções Finais

1. Faça o clone deste repositório, desenvolva as funcionalidades e realize os commits.
2. Suba o projeto de forma **privada** no **seu** Github.
3. Abra um Pull Request.
4. Adicione `wbotelhos@gmail.com` como colaborador no repositório.
