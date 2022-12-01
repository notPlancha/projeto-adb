---
title: "TODO titulo"
author: [André Plancha; 105289, Another Author; Num]
date: "2017-02-20"
---
# Info dump (TODO tratar e tirar antes de entregar)
count: 1308835
## colunas
* PlayerName: Nome do jogador
* Born: onde o jogador nasceu (cidade, pais)
* Height: altura do jogador (cm)
* Hand:  mão dominante, backhand
* LinkPlayer:  link para a página do jogador
* Tournament : nome do torneio
* Location : cidade, pais do torneio
* Date: periodo de tempo do jogo (AAAA.MM.DD - AAAA.MM.DD) ( pode-se tartar mas n vai ajudar nas perguntas)
* GameRound: fase do jogo (pode-se tratar mas n vai ajudar nas perguntas)
* GameRank: ATP Rankings do jogo? (int)
* WL: vitoria ou derrota (W ou L)
* Opponent: nome do oponente
* Score: resultado do jogo (set scores); Este campo é mais compicado, mas pra as perguntas n é preciso desenvolver (ou entender)
# Exemplo de uso do codigo (TODO tirar dps)
```javascript
db.collection.find({}).pretty()

```


```sql
select * from table where x=2;
```